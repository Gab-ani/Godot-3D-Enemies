extends Node
class_name AIMove
# much functional is duplicated with players Move, I'm currently thinking about
# identifying a common ancestor class for Move (new base ancestor) -> PlayerMove and Move -> AIMove
# not so sold on it tho, as player has both transition and updating dependent on input package, and
# an enemy doesn't. So all I save are some fields and reactions code. The classes might be just similar.

@export var move_name : String
@export var animation : String

var player : CharacterBody3D
var character : CharacterBody3D
var animator : AnimationPlayer
var spawn_point : Vector3
var right_weapon : Weapon
var resources : EnemyResources

var enter_state_time : float

func check_transition(delta) -> Array:
	return [true, "implement transition logic for " + move_name]


func update(delta):
	pass
 

func on_enter():
	pass


func on_exit():
	pass


func react_on_hit(hit : HitData):
	resources.lose_health(hit.damage)


# our little timestamps framework to work with timings inside our logic
func mark_enter_state():
	enter_state_time = Time.get_unix_time_from_system()

func get_progress() -> float:
	var now = Time.get_unix_time_from_system()
	return now - enter_state_time

func works_longer_than(time : float) -> bool:
	if get_progress() >= time:
		return true
	return false

func works_less_than(time : float) -> bool:
	if get_progress() < time: 
		return true
	return false

func works_between(start : float, finish : float) -> bool:
	var progress = get_progress()
	if progress >= start and progress <= finish:
		return true
	return false
