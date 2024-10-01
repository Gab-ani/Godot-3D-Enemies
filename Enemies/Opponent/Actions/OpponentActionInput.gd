extends Resource
class_name OpponentActionInput

var direction_input : Vector3

static func blank() -> OpponentActionInput:
	var blank_input = OpponentActionInput.new()
	blank_input.direction_input = Vector3.ZERO
	return blank_input
