extends Node
class_name OpponentBeliefs

@export var character : CharacterBody3D
@export var character_resources : OpponentResources
@export var actions_container : OpponentActionContainer
var player : CharacterBody3D

@onready var actions = $"../Actions" as OpponentActionContainer

var our_collision_radius : float = 0.3
var frame_duration = 0.016

var last_attack_timing : float

func get_agression() -> float:
	#print("agression " + str($Agression.get_value()))
	return $Agression.get_value()

func get_future_player_positions():
	return $FuturePlayerPosition.get_value()

# lazy shitcode TODO enchance for different floor levels
func player_to_us_direction() -> Vector3:
	return player.global_position.direction_to(character.global_position)

func character_direction_to(position : Vector3):
	return character.global_position.direction_to(position)

func character_distance_to(position : Vector3):
	return character.global_position.distance_to(position)

func character_direction_to_player() -> Vector3:
	return character.global_position.direction_to(player.global_position)

func character_sprint_speed() -> float:
	return actions.get_action("sprint").sprint_speed

func character_run_speed() -> float:
	return actions.get_action("run").run_speed

func player_position() -> Vector3:
	return player.global_position

func player_hp_percentage() -> float:
	return player.hp_percentage()

func character_hp_percentage() -> float:
	return character_resources.health / character_resources.max_health

func character_stamina_percentage() -> float:
	return character_resources.stamina / character_resources.max_stamina

func roll_is_available() -> bool:
	return character_resources.stamina > actions_container.get_action("roll").stamina_cost

func have_stamina_for_strike() -> bool:
	return character_resources.stamina > actions_container.get_action("longsword_1").stamina_cost

func have_stamina_for_cheese() -> bool:
	return character_resources.stamina > actions_container.get_action("cheese_throw").stamina_cost

func have_cheese_charge() -> bool:
	return actions_container.get_action("cheese_throw").charges > 0

func cheese_speed() -> float:
	# TODO tie with spell
	return 20

func distance_to_player() -> float:
	return character.global_position.distance_to(player.global_position)

func player_is_attacking() -> bool:
	return player.is_attacking()

func player_attack_radius() -> float:
	return player.current_attack_radius() + our_collision_radius

func time_til_players_attack_connection() -> float:
	return player.time_til_attack_connection()

func player_attacks_threateningly() -> bool:
	var closest_point = character.global_position + character_direction_to_player() * our_collision_radius
	return player_is_attacking() and in_players_attack_zone(closest_point)

func player_is_missing_attack() -> bool:
	var closest_point = character.global_position + character_direction_to_player() * our_collision_radius
	return player_is_attacking() and not in_players_attack_zone(closest_point)

func in_players_attack_zone(point : Vector3) -> bool:
	# required we call it presuming the current move is an attack
	return point.distance_to(player.current_move_initial_position()) < player_attack_radius()

func can_leave_attack_radius() -> bool:
	var distance_to_go = player_attack_radius() - distance_to_player()
	var distance_we_can_go = character_sprint_speed() * time_til_players_attack_connection()
	return distance_to_go < distance_we_can_go

func can_block_incoming_attack() -> bool:
	var enough_stamina = player_current_attack_damage() * blocking_coefficient() < character_resources.stamina
	return enough_stamina and distance_to_player() > 1.2

func player_current_attack_damage() -> float:
	# longsword_1 parameter currently TODO tie with weapon and attack managing layer
	return 20

func blocking_coefficient() -> float:
	return actions_container.get_action("block").block_coefficient

func character_is_blocking() -> bool:
	var current_action : String = character.current_behaviour.current_action.action_name
	return current_action == "block" or current_action == "block_reaction"

# til the extremum of the attack ark
func character_attack_radius() -> float:
	# longsword_1 parameter currently TODO tie with weapon and attack managing layer
	return 2.725

func character_can_attack_position(position : Vector3):
	return character_distance_to(position) < character_attack_radius()

# time when current weapon's collider is activated in the current attack
# i.e. time till the first harming frame
func character_attack_windup_time() -> float:
	# longsword_1 parameter currently TODO tie with weapon and attack managing layer
	return 0.65

func player_is_rolling() -> bool:
	return player.is_rolling()

func player_roll_time_left() -> float:
	return player.roll_time_left()

func players_roll_end_is_attackable() -> bool:
	var roll_endpoint = player.get_roll_endpoint()
	#$"../debug_sphere".global_position = roll_endpoint
	var difference = player_roll_time_left() - character_attack_windup_time()
	#print(difference)
	if character_can_attack_position(roll_endpoint) and difference < frame_duration and difference > 0:
		return true
	return false

#func players_move_is_attackable() -> bool:
	#var future_player_pos = player.get_current_move_position_after(character_attack_windup_time())
	#$"../debug_sphere".global_position = future_player_pos
	#return character_can_attack_position(future_player_pos)

func player_position_position_after(time : float) -> Vector3:
	var future_pos = player.get_current_move_position_after(time)
	#$"../debug_sphere".global_position = future_pos
	return future_pos

func player_attack_is_punishable() -> bool:
	var geometry_allows = player.current_move_posttracking_radius() + character_attack_radius() > distance_to_player()
	var time_allows = character_attack_windup_time() < player.current_attack_locked_time_left()
	return geometry_allows and time_allows

func player_time_til_next_last_locked_frame() -> float:
	return player.time_til_next_last_locked_frame()

# ideally private, don't use the funciton, use the feeling instead
func future_player_positions():
	return player.get_guaranteed_positions_list()

func cheese_throw_arm_length() -> float:
	# TODO tie with cheese throw action
	return 0.318

func cheese_throw_projectile_emit_timing() -> float:
	# TODO tie with cheese throw action
	return 0.919

func cheese_restore_duration() -> float:
	# TODO tie with cheese throw action
	return 3.6

func player_is_reloading_cheese() -> bool:
	return player.get_current_move().move_name == "cheese_throw_reload"






















