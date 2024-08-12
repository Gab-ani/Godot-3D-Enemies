extends Node
class_name HFSM

# The global export fields section. You don't need to set them up for each state,
# do only for the top layer single state that contains the whole state machine.
@export_group("Container Fields")
@export var animator : AnimationPlayer
@export var character : CharacterBody3D
@export var player : CharacterBody3D
@export var moves_data_repo : GundyrMovesData
@export var resources : HFSMResources
@export var weapons : Array[Weapon]

# These fields must be set for each state indivdually.
# states without animation and backend animation (containers) don't need animation field
@export_group("Move Fields")
@export var move_name : String
@export var animation : String
@export var backend_animation : String
var enter_state_time : float

var moves : Dictionary # { String : HFSM }
var current_move : HFSM = self   
var is_container : bool = false  # automatically sets to true if we have HFSM children


func _ready():
	_accept_substates()

# TransitionData has comments in class definition file
# This is a base implementation that fails fast if you forgot to specify the logic.
# Alternatively, you can make the base implementation "lazy" and lock it transitioning nowhere never.
# The plus is that you won't need do specify the method in heirs, the downside is 
# that the failing fast will be lost. Untill you really embraced the workflow, I recommend spamming
# the empty logics in new heirs, then just refactor it into the locked base method when you 
# start to feel comfortable thinking in HFSM designs.
func check_transition(_delta) -> TransitionData:
	return TransitionData.new(true, "implement transition logic for " + move_name) # failing fast
	#return TransitioData.new(false, "")

func choose_internal_move() -> TransitionData:
	return TransitionData.new(true, "implement first move choice logic for " + move_name) # failing fast

# This is being called on physics updates (probably).
# The top level state machine needs the method called from somewhere,
# in this demo we call it from physics update in the top level node Gundyr.
# This is internal method, to override updates use the update(delta) one.
func _update(delta : float):
	update(delta)
	if is_container:
		var verdict = current_move.check_transition(delta)
		if verdict.transitions:
			_switch_to(verdict.target_move)
		current_move._update(delta)


func update(_delta : float):
	pass


func _switch_to(move):
	if current_move != self:
		current_move._on_exit()
	current_move = moves[move]
	current_move._on_enter()
	if not current_move.is_container:
		print(current_move.animation) 
		animator.play(current_move.animation)

# this function is internal, it works and don't touch it, use on_enter() for customisation
func _on_enter():
	mark_enter_state()
	on_enter()
	if is_container:
		var first_move_transition = choose_internal_move()
		_switch_to(first_move_transition.target_move)

# this function is internal, it works and don't touch it, use on_exit() for customisation
func _on_exit():
	if is_container:
		current_move._on_exit()
	on_exit()

func on_exit():
	pass

func on_enter():
	pass

# I called on initialization phase, automatically builds the inner tree of HFSM
func _accept_substates():
	for child in get_children():
		if child is HFSM:
			is_container = true
			moves[child.move_name] = child

# Due to Godot's scene tree building mechanics (from bottom to top) this method needs
# to be called when the whole HFSM is initialized, so, in @ready of the top level node outside
# of the whole HFSM.
func _accept_export_fields():
	for move in moves.values():
		move.animator = animator
		move.character = character
		move.player = player
		move.moves_data_repo = moves_data_repo
		move.resources = resources
		move.weapons = weapons
		if move.is_container:
			move._accept_export_fields()

# in contrast with other interal functions that use "do your stuff then pass the call down the tree"
# reactions I did this way.
# This is due to reactions being heavily defaulted (almost all moves react on hit/parry in the same way)
# if that's the case, I'd better write a single default reaction and then call it once
# from the bottom leaf of the tree, the working move.
# Otherwise, we call it on each node in the tree and get damaged X times instead of one, for example
func _react_on_hit(hit : HitData):
	get_lowest_active_state().react_on_hit(hit)


func react_on_hit(hit : HitData):
	resources.lose_health(hit.damage)

# call this in update method int states that use weapons anyhow
func manage_weapons():
	for weapon in weapons:
		weapon.is_attacking = moves_data_repo.is_attacking(weapon.weapon_name, backend_animation, get_progress())

# this needs to be called on_exit of every state that touches weapons
# thanks to how our weapon collision detection works, we have a list of ignored victims for
# an attack. We clear that list on exit from an attack, plus also we deactivate weapons.
func deactivate_weapons():
	for weapon in weapons:
		weapon.hitbox_ignore_list.clear()
		weapon.is_attacking = false

# our little timestamps framework to work with timings inside our logic
func mark_enter_state():
	enter_state_time = Time.get_unix_time_from_system()

func get_progress() -> float:
	var now = Time.get_unix_time_from_system()
	return now - enter_state_time

func works_longer_than(time : float) -> bool:
	return get_progress() >= time

func works_less_than(time : float) -> bool:
	return get_progress() < time

func works_between(start : float, finish : float) -> bool:
	var progress = get_progress()
	return progress >= start and progress <= finish


# syntaxic sugar proxies
func get_animation_length() -> float:
	return animator.get_animation(animation).length

func distance_to_player() -> float:
	return character.global_position.distance_to(player.global_position)

func angle_to_player() -> float:
	return character.basis.z.angle_to(projected_direction_to_player())

func direction_to_player() -> Vector3:
	return character.global_position.direction_to(player.global_position)

func projected_direction_to_player() -> Vector3:
	return character.global_position.direction_to(get_projected_player_pos())

func get_projected_player_pos() -> Vector3:
	var player_pos = player.global_position
	player_pos.y = character.global_position.y
	return player_pos

func get_lowest_active_state() -> HFSM:
	if is_container:
		return current_move.get_lowest_active_state()
	return self

func coinflip() -> bool:
	return randi() % 2 == 1

# means that we most probably 1 or 2 frames from the end of the lifecycle
func close_to_the_end_of_animation() -> bool:
	return get_progress() / get_animation_length() > 0.98

# backend animations getters
func get_root_position_delta(delta : float):
	return moves_data_repo.get_root_delta_pos(backend_animation, get_progress(), delta)

func halberd_hurts() -> bool:
	return moves_data_repo.get_halberd_hurts(backend_animation, get_progress())

func kick_hurts() -> bool:
	return moves_data_repo.get_halberd_hurts(backend_animation, get_progress())

func shoulder_hurts() -> bool:
	return moves_data_repo.get_halberd_hurts(backend_animation, get_progress())

func aura_hurts() -> bool:
	return moves_data_repo.get_halberd_hurts(backend_animation, get_progress())




# So, how to use all this?
# First, I recommend to design something on paper or in other non-code frameworks.
# Then create a node and attach a new heir of HFSM to it, and select the new HFSM template.
# Then start from defining export fields: move_name always and animation + backed animation if needed.
# Then work with methods template suggests you: 
# First, if you new heir is a container, feel in the choose_internal_move() method
# or delete it if the new heir is bottom-level state.
# Then write down the transition logic for the new heir in check_transition.
# Then if you need, put some custom initializations or destructors in on_enter() and on_exit() methods
# Then lastly, write the update logic. 

# This is the most correct pipeline in my opinion, because the most important thing 
# for any state machine is its transtion logic, 
# and you can test those prior to having any actual updates, if you wrote other methods.

# General code guidelines are: use a shit ton of proxies.
# Ideally, your transition logic needs to consist of several if statements that check
# some single function calls with human readable names, almost like a sentence in english.
# I have a bunch of proxies already in this class under the section of syntaxic sugar, don't
# be ashamed to add your own, and define your own proxies in classes if you need. 
# Check the phase one Combat_1 script for example.
# If you need more complex behaviours, try to find a way to solve your problem
# using backend animations framework. You can learn how attacks lifecycle works to
# get the idea, in short, if you need some data, it's probably beneficial for you
# to work with that data with backend animations.
