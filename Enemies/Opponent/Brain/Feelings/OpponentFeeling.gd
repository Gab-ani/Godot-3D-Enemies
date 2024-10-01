extends Node
class_name OpponentFeeling
# A little class to represent a value that can have some relatively long calculation time 
# (in the scope of a frame), doesn't need to be exact, and can be requested by
# different sources.
# The idea is to calculate the value once in a while, store it and provide the stored result
# if asked shortly after last recalculation
@onready var beliefs = $".." as OpponentBeliefs

@export var trust_interval : float = 0.1 
var last_calculation : float = 0

var value


func get_value():
	if Time.get_unix_time_from_system() - last_calculation > trust_interval:
		recalculate()
		last_calculation = Time.get_unix_time_from_system()
	return value


func recalculate():
	pass
