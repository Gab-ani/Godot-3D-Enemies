extends AnimationPlayer

@onready var tree = $AnimationTree


func set_torso_animation(animation_name : String):
	var torso_node : AnimationNodeAnimation = tree.tree_root.get_node("Torso")
	torso_node.set_animation(animation_name)


func set_legs_animation(animation_name : String):
	var legs_node : AnimationNodeAnimation = tree.tree_root.get_node("Legs")
	legs_node.set_animation(animation_name)
