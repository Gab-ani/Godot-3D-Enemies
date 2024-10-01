extends Node
class_name OpponentActionContainer


@export var beliefs : OpponentBeliefs
@export var character : CharacterBody3D
@export var animator : AnimationPlayer
@export var actions_data : OpponentActionsData
@export var resources : OpponentResources

@export var right_hand_weapon : Weapon
@export var left_wrist : BoneAttachment3D

var actions : Dictionary # { String : OpponentAction }


func _ready():
	accept_actions()


func get_action(action_name : String):
	return actions[action_name]


func accept_actions():
	for child in get_children():
		if child is OpponentAction:
			child.beliefs = beliefs
			child.character = character
			child.resources = resources
			child.left_wrist = left_wrist
			child.action_data_repo = actions_data
			child.right_hand_weapon = right_hand_weapon
			actions[child.action_name] = child
			print(child.animation)
			# TODO take duration parameter from backend animations instead
			child.duration = animator.get_animation(child.animation).length
