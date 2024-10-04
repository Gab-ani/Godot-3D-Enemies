extends Node

@export var animation_player : AnimationPlayer
@export var character : CharacterBody3D
@export var right_weapon : Weapon
@export var resources : EnemyResources

var moves : Dictionary # { String : AIMove }
var current_move : AIMove


func _ready():
	accept_states()
	current_move = moves["idle"]
	switch_to("idle")


func _physics_process(delta):
	var verdict = current_move.check_transition(delta)
	if verdict[0]:
		switch_to(verdict[1])
	current_move.update(delta)


func switch_to(next_state_name : String):
	#print(current_move.move_name + " -> " + next_state_name)
	current_move.on_exit()
	current_move = moves[next_state_name]
	current_move.mark_enter_state()
	current_move.on_enter()
	animation_player.play(current_move.animation)


func accept_states():
	for child in get_children():
		if child is AIMove:
			moves[child.move_name] = child
			child.animator = animation_player
			child.character = character
			child.player = character.player
			child.right_weapon = right_weapon
			child.resources = resources


func accept_spawn_point():
	for child in get_children():
		if child is AIMove:
			child.spawn_point = character.spawn_point
