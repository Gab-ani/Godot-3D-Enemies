extends CharacterBody3D
class_name Spell


var caster : CharacterBody3D
var spell_name : String

var hitbox_ignore_list : Array[Area3D]


func get_hit_data() -> SpellHitData:
	print("someone tries to get hit by default Spell")
	return SpellHitData.blank()


func target_contacted(character : CharacterBody3D):
	queue_free()
