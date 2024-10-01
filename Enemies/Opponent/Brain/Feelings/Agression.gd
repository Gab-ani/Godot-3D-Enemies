extends OpponentFeeling

@export var self_preservation : Curve
@export var desire_to_execute : Curve
@export var stamina_preservation : Curve

func recalculate():
	value =  health_component() * stamina_component()


func health_component() -> float:
	var cowardice = self_preservation.sample(beliefs.character_hp_percentage())
	var hp_agression = desire_to_execute.sample(beliefs.player_hp_percentage())
	return (1 - cowardice) * hp_agression

func stamina_component() -> float:
	return (1 - stamina_preservation.sample(beliefs.character_stamina_percentage()))
