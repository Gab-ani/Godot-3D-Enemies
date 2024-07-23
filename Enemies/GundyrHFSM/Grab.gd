extends HFSM


func check_transition(delta) -> TransitionData:
	return TransitionData.new(true, "to what")

# update(delta) is the function that will be called every _physics_update(), put your logic here
func update(delta):
	pass


func on_exit():
	pass

