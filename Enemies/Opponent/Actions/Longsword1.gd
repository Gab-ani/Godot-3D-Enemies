extends OpponentAction


@export var hit_damage : float = 20
@export var releases_priority : float 

var initial_position : Vector3

func update(input : OpponentActionInput, delta : float):
	move_by_root_motion(delta)
	track_player_if_possible(input, delta)
	right_hand_weapon.is_attacking = right_weapon_hurts()


func form_hit_data(weapon : Weapon) -> HitData:
	var hit = HitData.new()
	hit.damage = hit_damage
	hit.hit_move_animation = animation
	hit.is_parryable = false
	#hit.is_parryable = is_parryable()
	hit.weapon = weapon
	return hit

func on_enter_action():
	initial_position = character.global_position
	beliefs.last_attack_timing = Time.get_unix_time_from_system()

func on_exit_action():
	right_hand_weapon.hitbox_ignore_list.clear()
	right_hand_weapon.is_attacking = false
