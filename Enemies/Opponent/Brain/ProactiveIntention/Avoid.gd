extends OpponentProactionIntention

@export var stamina_starve : Curve

func recalculate_intention():
	intention = stamina_starve.sample_baked(beliefs.character_stamina_percentage())
