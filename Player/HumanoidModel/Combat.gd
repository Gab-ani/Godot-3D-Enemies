extends Node
class_name HumanoidCombat

@onready var model = $".." as PlayerModel

@export_group("spellbook")
@export var shield_shot_charges : int = 1
@export var max_shield_shot_charges : int = 1


static var inputs_priority : Dictionary = {
	"light_attack_pressed" : 1,
	"heavy_attack_pressed" : 2,
}


func contextualize(new_input : InputPackage) -> InputPackage:
	TEMP_actualise_shieldshot(new_input)
	translate_inputs(new_input)
	filter_with_resources(new_input)
	return new_input


func translate_inputs(input : InputPackage):
	if not input.combat_actions.is_empty():
		input.combat_actions.sort_custom(combat_action_priority_sort)
		var best_input_action : String = input.combat_actions[0]
		var translated_into_move_name : String = model.active_weapon.basic_attacks[best_input_action]
		input.actions.append(translated_into_move_name)


func filter_with_resources(input : InputPackage):
	if model.resources.statuses.has("fatique"):
		input.actions.erase("sprint")

# This all has a temporary fleur because of inability to create a "tutorial" for spells and special abilities.
# While there are low amounts of WASD controllers, and there's a very limited
# number of ideas about i-frames, dodges, parries or melee hits,
# considering magic systems and special abilities, there are pretty much a system per game.
# So, there won't be an ultimate clean design for a spell until you'll start to create an actual game.
# Generally, of course spellbook must be a separate layer, and combat must filter the inputs using
# delegate calls to spellbook logic.
func TEMP_actualise_shieldshot(new_input : InputPackage):
	if shield_shot_charges < 1:
		new_input.actions.erase("shield_shot")
	if shield_shot_charges == max_shield_shot_charges:
		new_input.actions.erase("shield_shot_reload")


static func combat_action_priority_sort(a : String, b : String):
	if inputs_priority[a] > inputs_priority[b]:
		return true
	else:
		return false
