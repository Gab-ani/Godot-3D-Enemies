extends HFSM


func check_transition(_delta) -> TransitionData:
	return TransitionData.new(false, "")

# intuition tells to use it on_exit(), but we actually can't
# because there is no further progress to call switch_to,
# hence the on_exit() will never be called
func update(_delta):
	if close_to_the_end_of_animation():
		character.queue_free()
