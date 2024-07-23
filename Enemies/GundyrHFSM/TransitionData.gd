extends Resource
class_name TransitionData

var transitions : bool
var target_move : String

# think ten times before you do, but you can send other data between your states


func _init(verdict : bool, next_move : String):
	transitions = verdict
	target_move = next_move
