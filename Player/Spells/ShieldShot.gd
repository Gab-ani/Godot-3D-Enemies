extends Spell
class_name ShieldShot


@export var speed : float = 20
var lifetime : float = 1
var spawn_time : float
var damage = 30


func _ready():
	spawn_time = Time.get_unix_time_from_system()


func set_direction(vector : Vector3):
	velocity = vector * speed


func _physics_process(delta):
	move_and_slide()
	destroy_if_old()


func destroy_if_old():
	if Time.get_unix_time_from_system() - spawn_time > lifetime:
		queue_free()


func get_hit_data() -> SpellHitData:
	var spell_data = SpellHitData.new()
	spell_data.damage = damage
	spell_data.spell_name = "shield_shot"
	spell_data.spell = self
	return spell_data
