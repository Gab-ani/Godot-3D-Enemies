extends HFSM

@export_group("grab attack")
@export var min_grab_distance : float = 2
@export var max_grab_distance : float = 3
@export var grab_sector : float = 1             # radians
@export var grab_cooldown : float = 15
@export_group("gapclose attack")
@export var gap_close_distance : float = 8
@export_group("scare-off attack")
@export var max_scareoff_radius : float = 1.5
@export var back_sector : float = 1             # radians
@export_group("attack series")
@export var attack_series : HFSM
@export var aggro_drop_radius : float = 5

func check_transition(_delta) -> TransitionData:
	if conditioned_attack_ended() or attack_series_ended():
		return TransitionData.new(true, "chill_1")
	return TransitionData.new(false, "")

# if we performed one of scare-off, grab or gapclose attacks AND they just ended
func conditioned_attack_ended() -> bool:
	return ["scare_off", "grab", "gapclose"].has(current_move.move_name) and current_move.works_longer_than(current_move.get_animation_length())

# if we performed a random series of attacks
func attack_series_ended():
	#print(str(attack_series.attacks_to_do) + " attacks to do")
	return attack_series.ended


func choose_internal_move() -> TransitionData:
	#if can_grab_player():
		#return TransitionData.new(true, "grab")
	if player_too_far():
		return TransitionData.new(true, "gapclose")
	if player_too_close():
		return TransitionData.new(true, "scare_off")
	return TransitionData.new(true, "attack_series")


func can_grab_player() -> bool:
	if distance_to_player() > max_grab_distance:
		return false
	if distance_to_player() < min_grab_distance:
		return false
	if angle_to_player() > grab_sector / 2:
		return false
	return true

func player_too_far() -> bool:
	return distance_to_player() > gap_close_distance

func player_too_close() -> bool:
	if distance_to_player() > max_scareoff_radius:
		return false
	if angle_to_player() > 3.14 - back_sector / 2:
		return false
	return true


func on_exit():
	attack_series.ended = false
