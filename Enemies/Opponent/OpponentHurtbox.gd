extends Area3D
# Yeah, we are spamming hurtboxes and weapons that are heavilty duplicated.
# However, it's a forced measure because all our enemies have different implementations or
# slight structure changes for their processing state machines.
# Keep in mind that this project has like 4 different enemies ideas plus controller example assorti
# but your project will probably have "more determined" codebase with one-two implementation chosen.
class_name OpponentHurtbox

@export var processor : Opponent

# new way of defining allied weapons to not trigger on owned weapon etc.
@export var ignored_weapon_groups : Array[String]
# Later, in a complex environment I unironically think it's a better practice to completely
# separate spells and weapons (and later allied spells) processing.
# I envision three different collision detectors for each family of detectable object,
# placed on different collision layers.
# But for now it is what it is.
@export var ignored_spell_groups : Array[String]


func _physics_process(_delta):
	if has_overlapping_areas():
		for area in get_overlapping_areas():
			on_area_contact(area)
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			on_body_contact(body)


func on_area_contact(area : Node3D):
	#print(area.name)
	if is_eligible_attacking_weapon(area):
		area.hitbox_ignore_list.append(self)
		processor.react_on_hit(area.get_hit_data())


func on_body_contact(body : PhysicsBody3D):
	if is_eligible_attacking_spell(body):
		body.hitbox_ignore_list.append(self)
		processor.react_on_spell(body.get_hit_data())


func is_eligible_attacking_weapon(area : Node3D) -> bool:
	if area is Weapon and is_not_ignored(area) and not area.hitbox_ignore_list.has(self) and area.is_attacking:
		return true
	return false


func is_eligible_attacking_spell(body : PhysicsBody3D) -> bool:
	if body is Spell and is_not_ignored(body) and not body.hitbox_ignore_list.has(self):
		print("eligible spell " + body.name)
		return true
	return false


func is_not_ignored(area : Node3D) -> bool:
	for group in ignored_weapon_groups:
		if area.is_in_group(group):
			return false
	for group in ignored_spell_groups:
		if area.is_in_group(group):
			return false
	return true
