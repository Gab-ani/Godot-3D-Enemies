extends Node
class_name OpponentReactionIntention

@export var disabled : bool
@export var behaviour_name : String 
@export var competence_cost : float
@export var false_neg_chance : float

var beliefs : OpponentBeliefs

func _is_triggered() -> bool:
	return is_triggered() and not disabled and can_pay_competence_cost() and didnt_fail()

func is_triggered() -> bool:
	return false

func can_pay_competence_cost() -> bool:
	return beliefs.character_resources.competence > competence_cost

func didnt_fail() -> bool:
	print(randf() > false_neg_chance)
	return randf() > false_neg_chance
