extends OpponentReactionIntention


func is_triggered() -> bool:
	#if can_roll_punish():
		#print("can roll punish")
	return (can_roll_punish() or can_strike_punish()) and beliefs.have_stamina_for_strike()

# if player is rolling
# and final point of the roll is inside our attack radius
# and time to finish the roll is almost equal to our attack windup time
func can_roll_punish() -> bool:
	return beliefs.player_is_rolling() and beliefs.players_roll_end_is_attackable()


func can_strike_punish() -> bool:
	# if player is attacking, and can't reach us and our first attacking frame hits them
	return beliefs.player_is_missing_attack() and beliefs.player_attack_is_punishable()
