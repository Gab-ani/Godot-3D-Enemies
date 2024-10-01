extends OpponentBehaviour


func choose_action():
	var distance_to_go = beliefs.player_attack_radius() - beliefs.distance_to_player()
	var distance_we_can_go = beliefs.character_run_speed() * beliefs.time_til_players_attack_connection()
	if distance_to_go < distance_we_can_go:
		switch_to("run")
	else:
		switch_to("sprint")



func formulate_input(delta : float) -> OpponentActionInput:
	return input_away_from_player()

# while player is attacking and can hit us
func is_open_to_reconsiderations() -> bool:
	return not beliefs.player_attacks_threateningly()


func select_initial_action():
	enter_action("run")
