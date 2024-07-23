extends HFSM


var ended : bool = false
var attacks_to_do : int
@export var combo_starters : Array[HFSM]


func check_transition(_delta) -> TransitionData:
	return TransitionData.new(false, "")


func choose_internal_move() -> TransitionData:
	return TransitionData.new(true, combo_starters.pick_random().move_name)


func update(_delta):
	if distance_to_player() > 8 and current_move.close_to_the_end_of_animation():
		ended = true


func on_enter():
	ended = false
	attacks_to_do = randi_range(2,3)
	print(str(attacks_to_do) + " attacks to do:")
