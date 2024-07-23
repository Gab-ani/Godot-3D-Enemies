extends Node
class_name HFSM

@export_group("Container Fields")
@export var animator : AnimationPlayer
@export var character : CharacterBody3D
@export var player : CharacterBody3D
@export var moves_data_repo : GundyrMovesData
@export var resources : HFSMResources
@export var weapons : Array[Weapon]

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


func check_transition(_delta) -> TransitionData:
	return TransitionData.new(true, "implement transition logic for " + move_name) # failing fast

func choose_internal_move() -> TransitionData:
	return TransitionData.new(true, "implement first move choice logic for " + move_name) # failing fast

#
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

func _accept_substates():
	for child in get_children():
		if child is HFSM:
			is_container = true
			moves[child.move_name] = child

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


func manage_weapons():
	#print(move_name + " " + str(weapons.size()))
	for weapon in weapons:
		weapon.is_attacking = moves_data_repo.is_attacking(weapon.weapon_name, backend_animation, get_progress())
		#print(weapon.name + str(weapon.is_attacking))

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
