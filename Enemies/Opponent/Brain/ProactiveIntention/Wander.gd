extends OpponentProactionIntention


@export var from_agression : Curve


func recalculate_intention():
	intention = from_agression.sample(beliefs.get_agression())
	#print("wander " + str(intention))
