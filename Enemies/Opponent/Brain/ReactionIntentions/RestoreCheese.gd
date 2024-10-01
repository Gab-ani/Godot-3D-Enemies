extends OpponentReactionIntention


func is_triggered() -> bool:
	return cant_be_punished() and need_to_reload()


func need_to_reload() -> bool:
	return not beliefs.have_cheese_charge()


func cant_be_punished() -> bool:
	var release_animation_length = beliefs.cheese_throw_projectile_emit_timing()
	var distance = beliefs.distance_to_player()
	distance -= beliefs.cheese_throw_arm_length()
	var projectile_travel_time = distance / beliefs.cheese_speed()
	var punish_time = release_animation_length + projectile_travel_time
	#print(punish_time)
	return punish_time > beliefs.cheese_restore_duration()
