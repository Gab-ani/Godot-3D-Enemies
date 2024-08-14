extends Move

@export var spell_release_timing : float = 1
@export var spell : PackedScene
var casted = false


func update(_input : InputPackage, _delta : float):
	if works_longer_than(spell_release_timing) and not casted:
		spawn_spell()


func spawn_spell():
	var new_shield_shot : CheesThrow = spell.instantiate()
	new_shield_shot.caster = humanoid
	new_shield_shot.add_to_group("players_spell")
	add_child(new_shield_shot)
	new_shield_shot.global_position = left_wrist.global_position
	new_shield_shot.set_direction(humanoid.basis.z)
	casted = true
	combat.cheese_throw_charges = combat.cheese_throw_charges - 1
	#print(combat.shield_shot_charges)


func on_enter_state():
	casted = false
