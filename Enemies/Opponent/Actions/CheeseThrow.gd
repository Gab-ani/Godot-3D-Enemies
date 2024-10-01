extends OpponentAction

@export var spell_release_timing : float = 1
@export var spell : PackedScene
var charges : int = 1 
var casted : bool = false

func update(input : OpponentActionInput, delta : float):
	track_player_if_possible(input, delta)
	if works_longer_than(spell_release_timing) and not casted:
		spawn_spell()

func spawn_spell():
	var new_shield_shot : CheesThrow = spell.instantiate()
	new_shield_shot.caster = character
	new_shield_shot.add_to_group("opponents_spell")
	add_child(new_shield_shot)
	new_shield_shot.global_position = left_wrist.global_position
	new_shield_shot.set_direction(character.basis.z)
	casted = true
	charges -= 1
