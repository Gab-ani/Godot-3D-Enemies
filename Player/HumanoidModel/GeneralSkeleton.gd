extends Skeleton3D
class_name MixamoSkeleton

func add_torso_correction(r_x : float, r_y : float, r_z : float):
	var spine = find_bone("Spine")
	var current_transform = get_bone_global_pose_no_override(spine)
	var corrected_basis = current_transform.basis.rotated(Vector3.UP, deg_to_rad(r_y))
	corrected_basis = corrected_basis.rotated(Vector3.LEFT, deg_to_rad(r_x))
	corrected_basis = corrected_basis.rotated(Vector3.FORWARD, deg_to_rad(r_z))
	var corrected_transform = Transform3D(corrected_basis, current_transform.origin)
	set_bone_global_pose_override(spine, corrected_transform, 1, true)


func remove_torso_correction():
	var spine = find_bone("Spine")
	set_bone_global_pose_override(spine, Transform3D.IDENTITY, 0, true)


func get_torso_bones_indeces() -> Array:
	return get_hierarchy_indexes(1)


func get_legs_bones_indeces() -> Array:
	var right_leg_indeces = get_hierarchy_indexes(find_bone("RightUpperLeg"))
	var left_leg_indeces = get_hierarchy_indexes(find_bone("LeftUpperLeg"))
	var result = [0] # Hips
	result.append_array(right_leg_indeces)
	result.append_array(left_leg_indeces)
	return result

# we can't have a static index range here, because mixamo skeletons can slightly change, some
# have additional head IK, some don't, some we animate with additional rig, some not etc.
# However, there is a constant structure: 
# Hips bone always is a parent to Spine, RightUpperLeg and LeftUpperLeg.
func get_hierarchy_indexes(root_idx : int) -> Array:
	var indeces = []
	for child_bone in get_bone_children(root_idx):
		indeces.append_array(get_hierarchy_indexes(child_bone)) 
	indeces.append(root_idx)
	indeces.sort()
	return indeces
