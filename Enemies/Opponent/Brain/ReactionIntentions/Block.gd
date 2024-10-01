extends OpponentReactionIntention


func is_triggered() -> bool:
	var can_block = beliefs.can_block_incoming_attack()
	# tanking is less stamina than rolling and maybe some competence mixup
	# currently triggering at random to allow block/roll mix and match
	var want_block = randi() % 2 == 1
	return beliefs.player_attacks_threateningly() and can_block and want_block
