extends HFSM


var activated : bool = false


func check_transition(_delta) -> TransitionData:
	if activated:
		return TransitionData.new(true, "awakening")
	return TransitionData.new(false, "")


func _unhandled_input(event):
	if event.is_action_pressed("awake Gundyr"):
		activated = true
