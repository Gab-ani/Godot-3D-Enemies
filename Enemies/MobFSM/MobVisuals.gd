extends Node3D

@export var sword_visuals : Node3D
@export var sword : Node3D

func _process(delta):
	sword_visuals.global_transform = sword.global_transform
