extends OpponentProactionIntention

@export var from_distance : Curve
@export var max_distance : float = 20

func recalculate_intention():
	var normalized_distance = beliefs.distance_to_player() / max_distance
	intention = from_distance.sample(normalized_distance)
