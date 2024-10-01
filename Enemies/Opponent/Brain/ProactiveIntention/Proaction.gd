extends Node
class_name OpponentProactionIntention

@export var disabled : bool
@export var behaviour_name : String
@export var competence_cost : float 
var intention : float

var beliefs : OpponentBeliefs

func _recalculate_intention():
	if not disabled:
		recalculate_intention()
		if not can_pay_competence_cost():
			intention = 0


func recalculate_intention():
	pass

func can_pay_competence_cost() -> bool:
	return beliefs.character_resources.competence > competence_cost
