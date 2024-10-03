extends Node
class_name OpponentReactionIntention

@export var disabled : bool
@export var behaviour_name : String 
@export var competence_cost : float
#@export var false_neg_chance : float

# number of frames this reaction will autofail if asked
var brainfart_counter : int = 0
@export var brainfart_chance : float

var beliefs : OpponentBeliefs

func _is_triggered() -> bool:
	return is_triggered() and not disabled and can_pay_competence_cost() and didnt_fail()

func is_triggered() -> bool:
	return false

func can_pay_competence_cost() -> bool:
	return beliefs.character_resources.competence > competence_cost

func didnt_fail() -> bool:
	print(behaviour_name + " " + str(brainfart_counter))
	if brainfart_counter > 0:
		brainfart_counter -= 1
		return false
	else:
		if randf() < brainfart_chance:
			print(behaviour_name + " brainfarted")
			brainfart_counter = 12 # I took 12 frames to simulate somewhat human speed reaction
			return false
		return true
