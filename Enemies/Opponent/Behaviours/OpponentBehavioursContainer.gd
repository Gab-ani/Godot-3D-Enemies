extends Node
class_name OpponentsBehaviourContainer


@onready var animation_player = $"../AnimationPlayer"
var behaviours : Dictionary # { String : OpponentBehaviour }
@export var actions_container : OpponentActionContainer
@export var beliefs : OpponentBeliefs
@export var character : CharacterBody3D
@export var resources : OpponentResources

func _ready():
	accept_behaviours()


func get_behaviour(behaviour_name : String) -> OpponentBehaviour:
	return behaviours[behaviour_name]


func accept_behaviours():
	for child in get_children():
		if child is OpponentBehaviour:
			child.actions_container = actions_container
			child.animator = animation_player
			child.character = character
			child.resources = resources
			#child.set_initial_action()
			child.beliefs = beliefs
			behaviours[child.behaviour_name] = child
