extends CharacterBody3D

@export var player : CharacterBody3D

@export var speed : float = 3
@export var return_speed : float = 9

@export var aggro_radius : float = 8
@export var attack_radius : float = 2
@export var deaggro_radius : float = 10

var spawn_point : Vector3


func accept_spawn_point():
	spawn_point = global_position
	$StateMachine.accept_spawn_point()
