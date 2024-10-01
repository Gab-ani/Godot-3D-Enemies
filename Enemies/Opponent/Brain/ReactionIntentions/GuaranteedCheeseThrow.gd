extends OpponentReactionIntention


func is_triggered() -> bool:
	return can_throw() and will_hit()


func can_throw() -> bool:
	return beliefs.have_stamina_for_cheese() and beliefs.have_cheese_charge()


func will_hit() -> bool:
	return beliefs.player_is_missing_attack() or beliefs.player_is_reloading_cheese() # or can_hit_roll



# leaving this trashpile here commented to show what else I tried
## garbagegarbagegarbage, TODO probably just case-processing like reloading, strikes etc,
## universal approaches seem to work shitty, doesn't trigger on what it should and triggers on what it should not.
#func will_hit() -> bool:
	## all player's positions approach fails => let's try to snipe one point.
	## ideal candidate is the last frame of current animation if it is locking
	#var snipe_timing = beliefs.player_time_til_next_last_locked_frame()
	#var snipe_position = beliefs.player_position_position_after(snipe_timing)
	#var distance = beliefs.character_distance_to(snipe_position)
	#distance -= beliefs.cheese_throw_arm_length()
	#var cheese_arrival_time = (distance / beliefs.cheese_speed()) + beliefs.cheese_throw_projectile_emit_timing()
	##print("cheese will be there in " + str(cheese_arrival_time))
	#var difference = cheese_arrival_time - snipe_timing
	##if difference < 0.01 and difference > 0:
		##print("will hit cheese!")
	#return difference < 0.01 and difference > 0

# idk exactly why, but this functional fucking breaks everything.
# needs debugging, I don't thing it's that hard, until then, we are
# "sniping" the last frame of animation, sadly(
#func will_hit() -> bool:
	#var future_player_positions = beliefs.get_future_player_positions()
	#for time_pos in future_player_positions:
		#if hit_predicted(time_pos):
			#return true
	#return false
#
#func hit_predicted(time_pos : Array) -> bool:
	#var distance = beliefs.character_distance_to(time_pos[1])
	#distance -= beliefs.cheese_throw_arm_length()
	#var cheese_arrival_time = distance / beliefs.cheese_speed()
	#var difference = Time.get_unix_time_from_system() + cheese_arrival_time - time_pos[0]
	#return difference < 0.01
