extends Weapon
class_name Sword


func _ready():
	base_damage = 10
	basic_attacks = {
		"light_attack_pressed" : "greatsword_light_1",
		"heavy_attack_pressed" : "greatsword_heavy_1"
	}


func get_hit_data():
	return holder.current_move.form_hit_data(self)
