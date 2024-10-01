extends Weapon
class_name OpponentWeapon


func get_hit_data():
	return holder.form_hit_data(self)
