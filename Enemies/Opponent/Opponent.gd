extends CharacterBody3D
class_name Opponent

@export var player : CharacterBody3D

@onready var animator = $AnimationPlayer
@onready var behaviours = $Behaviours as OpponentsBehaviourContainer
var current_behaviour : OpponentBehaviour
@onready var brain = $Brain as OpponentBrain
@onready var beliefs = $Beliefs as OpponentBeliefs
@onready var resources = $Resources as OpponentResources


func _ready():
	beliefs.player = player
	current_behaviour = behaviours.get_behaviour("idle")
	current_behaviour._on_enter_behaviour()


func _physics_process(delta):
	if current_behaviour._is_open_to_reconsiderations():
		var most_intended_behaviour = brain.get_most_intended_behaviour()
		if behaviour_needs_to_change(most_intended_behaviour):
			switch_to(most_intended_behaviour)
	current_behaviour._update(delta)

func behaviour_needs_to_change(most_intended_behaviour : String) -> bool:
	return not most_intended_behaviour == current_behaviour.behaviour_name or current_behaviour.forced_to_reconsider


func switch_to(next_behaviour : String):
	current_behaviour._on_exit_behaviour()
	current_behaviour = behaviours.get_behaviour(next_behaviour)
	current_behaviour._on_enter_behaviour()


# proxy delegates for cleaner encapsulation
func react_on_hit(hit : HitData):
	current_behaviour.react_on_hit(hit)

func react_on_spell(spell_hit : SpellHitData):
	current_behaviour.react_on_spell(spell_hit)

func force_reconsideration():
	current_behaviour.forced_to_reconsider = true

func form_hit_data(weapon : OpponentWeapon) -> HitData:
	return current_behaviour.current_action.form_hit_data(weapon)

func try_force_action(next_action : String):
	current_behaviour.try_force_action(next_action)



