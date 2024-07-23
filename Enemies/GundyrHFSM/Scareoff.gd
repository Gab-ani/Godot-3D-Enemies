extends HFSM


@export var hit_damage : float = 30


func check_transition(_delta) -> TransitionData:
	return TransitionData.new(false, "")


func form_hit_data(weapon : Weapon) -> HitData:
	var hit = HitData.new()
	hit.damage = hit_damage
	hit.hit_move_animation = animation
	#hit.is_parryable = is_parryable()
	hit.weapon = weapon
	return hit


func update(_delta):
	manage_weapons()


func on_exit():
	deactivate_weapons()

