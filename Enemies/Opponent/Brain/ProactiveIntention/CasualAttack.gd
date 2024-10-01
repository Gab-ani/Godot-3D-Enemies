extends OpponentProactionIntention

@export var feel_of_disctance : Curve
@export var impatience : Curve
var max_impatience_tolerance : float = 8 # seconds after we have maximum impatinence component

func recalculate_intention():
	var aggression_part = beliefs.get_agression()
	var normalized_distance = beliefs.distance_to_player() / beliefs.character_attack_radius()
	var distance_part = feel_of_disctance.sample(normalized_distance)
	var normalised_peaceduration = (Time.get_unix_time_from_system() - beliefs.last_attack_timing) / max_impatience_tolerance
	aggression_part += impatience.sample(normalised_peaceduration)
	intention = aggression_part * distance_part
	
