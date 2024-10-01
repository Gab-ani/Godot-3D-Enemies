extends Node
class_name OpponentBehaviour


@export var behaviour_name : String
#@export var default_action : String
var character : CharacterBody3D
var animator : AnimationPlayer
var beliefs : OpponentBeliefs
var resources : OpponentResources
var actions_container : OpponentActionContainer
var current_action : OpponentAction

# a flip-flop flag used in a single tick to drop the current plan.
# in the current system state is used by stagger action, 
# so every time Opponent takes a hit, it reconsiders the behaviour (because current is a failure)
var forced_to_reconsider : bool = false

# fields to route internal transition of actions inside one behaviour,
# solves the problem of multiple simultaneous transitions, for example death from a hit.
# we take a hit -> we want to go to "staggered" action,
# but this hit also might reduce our hitpoints below 0 and we want to go to "death" action.
# Generally, try to use forced_action approach with try_force_action() method 
# and limit switch_to usage, it's used in the main lifecycle flow and is thought out.
var has_forced_action : bool = false
var forced_action : String = "idle"


func switch_to(next_action : String):
	current_action.on_exit_action()
	current_action = actions_container.get_action(next_action)
	current_action._on_enter_action()
	animator.play(current_action.animation)
	has_forced_action = false
	forced_action = "idle"

func update_resources(delta : float):
	resources.update(delta)

func _update(delta):
	update_resources(delta)
	_choose_action()
	var input = formulate_input(delta)
	update(input, delta)

func _choose_action():
	if current_action.is_locked_in_animation():
		return
	if has_forced_action:
		switch_to(forced_action)
		return
	choose_action()

func choose_action():
	pass

func update(input : OpponentActionInput, delta ):
	current_action.update(input, delta)

func try_force_action(next_action : String):
	var current_forced_action : OpponentAction = actions_container.get_action(forced_action)
	var potential_next_action : OpponentAction = actions_container.get_action(next_action)
	print("current forced " + current_forced_action.action_name + ". potential forced " + potential_next_action.action_name)
	if current_forced_action.priority < potential_next_action.priority:
		forced_action = next_action
		has_forced_action = true
		print("has forced action: " + forced_action)

func formulate_input(delta : float) -> OpponentActionInput:
	return OpponentActionInput.blank()


func _is_open_to_reconsiderations() -> bool:
	if forced_to_reconsider:
		return true
	if current_action.is_locked_in_animation():
		return false
	return is_open_to_reconsiderations()


func is_open_to_reconsiderations() -> bool:
	return false


func _on_enter_behaviour():
	select_initial_action()
	on_enter_behaviour()

func on_enter_behaviour():
	pass

func _on_exit_behaviour():
	forced_to_reconsider = false
	current_action.on_exit_action()
	on_exit_behaviour()

func on_exit_behaviour():
	pass


func enter_action(next_action : String):
	current_action = actions_container.get_action(next_action)
	current_action._on_enter_action()
	animator.play(current_action.animation)


func select_initial_action():
	enter_action("idle")


func react_on_hit(hit : HitData):
	#print("got hit, behaviour: " + behaviour_name + ", action: " + current_action.action_name)
	if current_action.is_vulnerable():
		resources.lose_health(hit.damage)
	if current_action.is_interruptable():
		#print("interruptable, should be staggered")
		try_force_action("staggered")


func react_on_spell(spell_hit : SpellHitData):
	if current_action.is_vulnerable():
		resources.lose_health(spell_hit.damage)
	if current_action.is_interruptable():
		try_force_action("staggered")
	spell_hit.spell.target_contacted(beliefs.character)


func input_towards_player() -> OpponentActionInput:
	var next_input = OpponentActionInput.new()
	next_input.direction_input = beliefs.character_direction_to_player()
	return next_input

func input_away_from_player() -> OpponentActionInput:
	var next_input = OpponentActionInput.new()
	next_input.direction_input = beliefs.player_to_us_direction()
	return next_input







