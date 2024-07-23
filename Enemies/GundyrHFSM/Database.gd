extends AnimationPlayer


@export var root_pos : Vector3
@export var halberd_hurts : bool
@export var shoulder_hurts : bool
@export var kick_hurts : bool
@export var aura_hurts : bool


func get_boolean_value(animation : String, track : int, timecode : float) -> bool:
	var data = get_animation(animation)
	return data.value_track_interpolate(track, timecode)
