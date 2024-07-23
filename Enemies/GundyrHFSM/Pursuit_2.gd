extends HFSM


@export var pursuit_drop_radius : float = 3.5
@export var speed = 6

# check_transition is the transition logic for transitioning on the same level as current node
func check_transition(_delta) -> TransitionData:
	if distance_to_player() < pursuit_drop_radius:
		return TransitionData.new(true, "slash_4")
	return TransitionData.new(false, "")


func update(_delta : float):
	character.look_at(get_projected_player_pos(), Vector3.UP, true)
	character.velocity = character.basis.z * speed
	character.move_and_slide()

