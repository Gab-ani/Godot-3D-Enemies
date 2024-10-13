extends Node
class_name MovesDataRepository

@export var move_database : AnimationPlayer


func get_root_delta_pos(animation : String, progress : float, delta : float) -> Vector3:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:root_position", Animation.TYPE_VALUE)
	if data.track_get_key_count(track) == 0:
		return Vector3.ZERO
	var previous_pos = data.value_track_interpolate(track, progress - delta)
	var current_pos = data.value_track_interpolate(track, progress)
	var delta_pos = current_pos - previous_pos
	return delta_pos

# TODO refactor named methods with proxy for getting a bool parameter
func get_transitions_to_queued(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:transitions_to_queued", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode) 

func get_accepts_queueing(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:accepts_queueing", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode) 

func get_vulnerable(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:is_vulnerable", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode) 

func get_interruptable(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:is_interruptable", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode) 

func get_parryable(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:is_parryable", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode)

func get_duration(animation : String) -> float:
	return move_database.get_animation(animation).length

func get_right_weapon_hurts(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:right_hand_weapon_hurts", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode)

func tracks_input_vector(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:tracks_input_vector", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode)

func time_til_next_controllable_frame(animation : String, timecode : float) -> float:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:tracks_input_vector", Animation.TYPE_VALUE)
	var keys = data.track_get_key_count(track)
	for key in keys:
		if data.track_get_key_time(track, key) >= timecode and data.track_get_key_value(track, key) == false:
			return data.track_get_key_time(track, key) - timecode
	return data.length - timecode

func ff_gapcloses(animation : String, timecode : float) -> bool:
	var data = move_database.get_animation(animation)
	var track = data.find_track("MoveDatabase:ff_gapcloses", Animation.TYPE_VALUE)
	return move_database.get_boolean_value(animation, track, timecode)

