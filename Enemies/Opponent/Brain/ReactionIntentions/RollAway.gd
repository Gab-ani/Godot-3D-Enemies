extends OpponentReactionIntention


func is_triggered() -> bool:
	var need_to_dodge : bool = beliefs.player_attacks_threateningly()
	var can_roll : bool = beliefs.roll_is_available()
	#var roll_will_help : bool = beliefs.distance_to_player() + beliefs.roll_distance() > beliefs.player_attack_radius()
	return  need_to_dodge and can_roll
