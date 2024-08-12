extends AnimationTree
class_name BodyPartsBlender

@export var model : PlayerModel
var full_body_mode : bool = true

# thanks, I hate it
var current_legs_node : String = "Legs1"
var next_legs_node : String = "Legs2"
var current_torso_node : String = "Torso1"
var next_torso_node : String = "Torso2"


func update_body_animations():
	update_playmode()
	set_animations()


func update_legs_animation():
	update_playmode()
	set_legs_animation(model.legs.current_legs_move.animation)


func clear_torso_animation():
	set("parameters/BodyBlend/blend_amount", 0)
	full_body_mode = true
	#print(next_torso_node)
	tree_root.get_node(next_torso_node).animation = "idle_longsword"
	tree_root.get_node(current_torso_node).animation = "idle_longsword"


func set_animations():
	if full_body_mode:
		if get_current_legs_animation() != model.current_move.animation:
			set_legs_animation(model.current_move.animation)
	else:
		#print("split mode, legs: " + tree_root.get_node(current_legs_node).animation + ", torso: " + tree_root.get_node(current_torso_node).animation)
		if get_current_legs_animation() != model.legs.current_legs_move.animation:
			set_legs_animation(model.legs.current_legs_move.animation)
		if get_current_torso_animation() != model.current_move.animation:
		#	print("changing torso from " + get_current_torso_animation() + " to " + model.current_move.animation)
			set_torso_animation(model.current_move.animation)


func set_legs_animation(animation : String):
	# request transition to the next "state" of transition (the names are equal to Animation nodes)
	tree_root.get_node(next_legs_node).animation = animation
	set("parameters/LegsTransition/transition_request", next_legs_node)
	# then flip the nodes order because fuck you I guess.
	var temp = current_legs_node
	current_legs_node = next_legs_node
	next_legs_node = temp


func set_torso_animation(animation : String):
	# request transition to the next "state" of transition (the names are equal to Animation nodes)
	tree_root.get_node(next_torso_node).animation = animation
	set("parameters/TorsoTransition/transition_request", next_torso_node)
	# then flip the nodes order because fuck you I guess.
	var temp = current_torso_node
	current_torso_node = next_torso_node
	next_torso_node = temp


func update_playmode():
	if model.current_move is TorsoPartialMove:
		set("parameters/BodyBlend/blend_amount", 1)
		full_body_mode = false
	if not model.current_move is TorsoPartialMove:
		set("parameters/BodyBlend/blend_amount", 0)
		full_body_mode = true


func get_current_legs_animation() -> String:
	return tree_root.get_node(current_legs_node).animation

func get_current_torso_animation() -> String:
	return tree_root.get_node(current_torso_node).animation
