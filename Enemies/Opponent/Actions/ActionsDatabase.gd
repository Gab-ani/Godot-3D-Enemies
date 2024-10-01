extends Node
class_name OpponentActionsData

@export var actions_data : AnimationPlayer

# duplication, TODO unify with existing DB in player's model after refactoring of it
func get_root_delta_pos(animation : String, progress : float, delta : float) -> Vector3:
	var data = actions_data.get_animation(animation)
	var track = data.find_track("ActionsData:root_position", Animation.TYPE_VALUE)
	var previous_pos = data.value_track_interpolate(track, progress - delta)
	var current_pos = data.value_track_interpolate(track, progress)
	var delta_pos = current_pos - previous_pos
	return delta_pos

func get_vulnerable(animation : String, timecode : float) -> bool:
	var data = actions_data.get_animation(animation)
	var track = data.find_track("ActionsData:is_vulnerable", Animation.TYPE_VALUE)
	return actions_data.get_boolean_value(animation, track, timecode) 

func get_interruptable(animation : String, timecode : float) -> bool:
	var data = actions_data.get_animation(animation)
	var track = data.find_track("ActionsData:is_interruptable", Animation.TYPE_VALUE)
	return actions_data.get_boolean_value(animation, track, timecode) 

func get_tracking(animation : String, timecode : float) -> bool:
	var data = actions_data.get_animation(animation)
	var track = data.find_track("ActionsData:tracks_input_vector", Animation.TYPE_VALUE)
	return actions_data.get_boolean_value(animation, track, timecode) 

func right_weapon_hurts(animation : String, timecode : float) -> bool:
	var data = actions_data.get_animation(animation)
	var track = data.find_track("ActionsData:right_weapon_hurts", Animation.TYPE_VALUE)
	return actions_data.get_boolean_value(animation, track, timecode) 

func locks_in_animation(animation : String, timecode : float) -> bool:
	var data = actions_data.get_animation(animation)
	var track = data.find_track("ActionsData:locks_in_animation", Animation.TYPE_VALUE)
	return actions_data.get_boolean_value(animation, track, timecode) 
	
	
	
	
