extends HFSM


@export var speed : float = 0.65
@export var tracking_angular_speed : float = 2
var direction_decider : int   # 1 or -1


func on_enter():
	if coinflip():
		direction_decider = -1
		animation = "strafe_left"
	else:
		direction_decider = 1
		animation = "strafe_right"


func check_transition(_delta):
	return TransitionData.new(false, "")

# The Lazy way to do this, not the circular movement, 
# but noone will notice, it's for 4 seconds on low speeds, in a fight...
func update(delta : float):
	character.look_at(get_projected_player_pos(), Vector3.UP, true)
	character.velocity = Vector3.UP.cross(direction_to_player()) * speed * direction_decider
	character.move_and_slide()
