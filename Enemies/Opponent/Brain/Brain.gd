extends Node
class_name OpponentBrain

@onready var reactions_container = $Reactions
@onready var proactions_container = $Proactions

var reactions : Array[OpponentReactionIntention]
var proactions : Array[OpponentProactionIntention]
@export var default_proaction : OpponentProactionIntention

@export var beliefs : OpponentBeliefs
@export var resources : OpponentResources

@onready var brain_debug_panel = $"../brain_debug_panel"

func _ready():
	accept_reactions()
	accept_proactions()


func get_most_intended_behaviour() -> String:
	for reaction in reactions:
		if reaction._is_triggered():
			resources.lose_competence(reaction.competence_cost)
			return reaction.behaviour_name
	return most_intended_proaction()


func most_intended_proaction() -> String:
	brain_debug_panel.text = ""                 # <-----DEV-----
	var current_best_choice = default_proaction # which is set to Idle, i.e. do nothing
	for proaction in proactions:
		proaction._recalculate_intention()
		if proaction.intention > current_best_choice.intention:
			current_best_choice = proaction
		# -----DEV-----:
		brain_debug_panel.text += proaction.behaviour_name + " " + str(snapped(proaction.intention, 0.01)) + "\n"
	resources.lose_competence(current_best_choice.competence_cost)
	brain_debug_panel.text += "health: " + str(snapped(resources.health, 1))
	return current_best_choice.behaviour_name


func accept_reactions():
	for child in reactions_container.get_children():
		if child is OpponentReactionIntention:
			child.beliefs = beliefs
			reactions.append(child)


func accept_proactions():
	for child in proactions_container.get_children():
		if child is OpponentProactionIntention:
			child.beliefs = beliefs
			proactions.append(child)

