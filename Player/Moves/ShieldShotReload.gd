#extends TorsoPartialMove
extends Move

@export var charge_restore_timing : float = 3.5
var reloaded = false

func update(_input, _delta):
	if works_longer_than(charge_restore_timing) and not reloaded:
		combat.shield_shot_charges = combat.shield_shot_charges + 1
		reloaded = true


func on_exit_state():
	reloaded = false
