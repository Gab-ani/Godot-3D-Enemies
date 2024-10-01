extends AnimationPlayer


@export var is_interruptable : bool
@export var is_vulnerable : bool
@export var locks_in_animation : bool
@export var right_weapon_hurts : bool
@export var root_position : Vector3
@export var tracks_input_vector : bool

func get_boolean_value(animation : String, track : int, timecode : float) -> bool:
	var data = get_animation(animation)
	return data.value_track_interpolate(track, timecode)
