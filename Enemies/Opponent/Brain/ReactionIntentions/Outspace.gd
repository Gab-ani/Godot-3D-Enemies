extends OpponentReactionIntention



func is_triggered() -> bool:
	if beliefs.player_attacks_threateningly() and beliefs.can_leave_attack_radius():
		return true
	return false
