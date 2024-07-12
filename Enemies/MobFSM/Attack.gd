extends AIMove


@export var animation_length : float
@export var hit_damage : int = 20

func check_transition(delta) -> Array:
	if works_longer_than(animation_length):
		if player.global_position.distance_to(character.global_position) < character.attack_radius:
			return [true, "attack"]
		if player.global_position.distance_to(spawn_point) > character.deaggro_radius:
			return [true, "return"]
		return [true, "pursuit"]
	return [false, ""]



func update(delta):
	rotate_towards_player()
	manage_weapon()


func manage_weapon():
	if works_between(0.4786, 0.7185):
		right_weapon.is_attacking = true
	else:
		right_weapon.is_attacking = false


func on_exit():
	right_weapon.hitbox_ignore_list.clear()
	right_weapon.is_attacking = false


func form_hit_data(weapon : Weapon) -> HitData:
	var hit = HitData.new()
	hit.damage = hit_damage
	hit.hit_move_animation = animation
	hit.weapon = weapon
	return hit


# wanna be a tracking window
# for better approach (smooth and easily editable turns) you can watch my MM3 video about tracking
# and controller series ep.4 for backend animations framework
func rotate_towards_player():
	if works_less_than(0.2):
		var grounded_player_pos = player.global_position
		grounded_player_pos.y = character.global_position.y
		character.look_at(grounded_player_pos)
