extends Weapon
class_name Sword


func _ready():
	base_damage = 10
	basic_attacks = {
		"light_attack_pressed" : "GS_FF_L1",
		"heavy_attack_pressed" : "GS_FF_H1"
	}


func get_hit_data():
	return holder.current_move.form_hit_data(self)
