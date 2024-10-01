extends Node
class_name OpponentResources

@export var health : float = 100
@export var max_health : float = 100

@export var stamina : float = 100
@export var max_stamina : float = 100
@export var stamina_regeneration_rate : float = 10  # per sec, because then we'll multiply on delta

var max_competence : float = 100
@export var competence : float = 100
@export var competence_regeneration_rate : float = 2

@onready var character = $".." as Opponent
#@onready var model = $".." as PlayerModel

#var statuses : Array[String]
#const FATIQUE_TRESHOLD = 20


func update(delta : float):
	gain_stamina(stamina_regeneration_rate * delta)
	gain_competence(competence_regeneration_rate * delta)

func update_without_stamina(delta : float):
	gain_competence(competence_regeneration_rate * delta)


func pay_resource_cost(action : OpponentAction):
	lose_stamina(action.stamina_cost)


func pay_block_cost(damage : float, blocking_coefficient : float):
	if damage * blocking_coefficient <= stamina:
		lose_stamina(damage * blocking_coefficient)
	else:
		var unblocked_portion = damage - stamina / blocking_coefficient
		lose_stamina(stamina)
		lose_health(unblocked_portion)
		# do some punishing shit like force guardbreak or smth
		print("opponent was guardbroken")


func can_be_paid(action : OpponentAction) -> bool:
	if stamina > 0 or action.stamina_cost == 0:
		return true
	return false

func lose_health(amount : float):
	print("opponent loses " + str(amount) + " health")
	health -= amount
	if health < 1:
		character.try_force_action("death")
		#model.current_move.try_force_move("death")


func gain_health(amount : float):
	if health + amount <= max_health:
		health += amount
	else:
		health = max_health


func lose_stamina(amount : float):
	stamina -= amount
	#if stamina < 1:
		#statuses.append("fatique")


func gain_stamina(amount : float):
	if stamina + amount < max_stamina:
		stamina += amount
	else:
		stamina = max_stamina
	#if stamina > FATIQUE_TRESHOLD:
		#statuses.erase("fatique")

func gain_competence(amount : float):
	if competence + amount < max_competence:
		competence += amount
	else:
		competence = max_competence

func lose_competence(amount : float):
	competence -= amount
