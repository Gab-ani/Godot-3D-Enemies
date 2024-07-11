extends CharacterBody3D

@export var player : CharacterBody3D
@onready var animation_player = $idle_longsword_left/AnimationPlayer

var spawn_point : Vector3

var aggro_radius : float = 5
var deaggro_radius : float = 8
var attack_radius : float = 2

enum Modes {IDLE, AGGROED, RETURNING} # poor man's states
var current_mode : Modes = Modes.IDLE

var SPEED = 3


func _ready():
	spawn_point = global_position


func _physics_process(delta):
	if player.global_position.distance_to(spawn_point) < aggro_radius and current_mode == Modes.IDLE:
		current_mode = Modes.AGGROED
	if player.global_position.distance_to(spawn_point) > deaggro_radius and current_mode == Modes.AGGROED:
		current_mode = Modes.RETURNING
	if current_mode == Modes.RETURNING and global_position.distance_to(spawn_point) < 0.1:
		current_mode = Modes.IDLE
		animation_player.play("idle")
	
	if current_mode == Modes.AGGROED:
		if player.global_position.distance_to(global_position) < attack_radius:
			look_at(player.global_position)
			animation_player.play("slash_1")
			print("attacking")
		else:
			look_at(player.global_position)
			velocity = global_position.direction_to(player.global_position) * SPEED
			animation_player.play("run")
			move_and_slide()
		return
	
	if current_mode == Modes.RETURNING:
		look_at(spawn_point)
		velocity = global_position.direction_to(spawn_point) * SPEED
		move_and_slide()
		
		
		
		
		
		
		
		
		
		
		
		
	
	
	
