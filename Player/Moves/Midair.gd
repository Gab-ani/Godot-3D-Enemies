extends Move

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var downcast = $"../../Downcast"
@onready var root_attachment = $"../../Root"

@export var DELTA_VECTOR_LENGTH = 6
var jump_direction : Vector3

var landing_height : float = 1.163


func default_lifecycle(_input : InputPackage):
	var floor_point = downcast.get_collision_point()
	if root_attachment.global_position.distance_to(floor_point) < landing_height:
		var xz_velocity = humanoid.velocity
		xz_velocity.y = 0
		if xz_velocity.length_squared() >= 10:
			return "landing_sprint"
		return "landing_run"
	else:
		return "okay"


func update(_input : InputPackage, delta ):
	humanoid.velocity.y -= gravity * delta
	humanoid.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var input_direction = (humanoid.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	var input_delta_vector = input_direction * DELTA_VECTOR_LENGTH
	
	jump_direction = (jump_direction + input_delta_vector * delta).limit_length(clamp(humanoid.velocity.length(), 1, 999999))
	humanoid.look_at(humanoid.global_position - jump_direction)
	
	var new_velocity = (humanoid.velocity + input_delta_vector * delta).limit_length(humanoid.velocity.length())
	humanoid.velocity = new_velocity


func on_enter_state():
	# the clamp construction is here to 
	# 1) prevent look_at annoying errors when our velocity is zero and it can't look_at properly
	# 3) have a way to scale from velocity. The longer the vector is, the harder it is to modify it by adding a delta.
	#    Scaling jump_direction with velocity is giving us that natural behaviour of faster jumps (sprints)
	#    being less controllable, and jumps from standing position being more volatile.
	#    The dependance on velocity paramter is not critical, delete this if you don't like the approach.
	jump_direction = Vector3(humanoid.basis.z) * clamp(humanoid.velocity.length(), 1, 999999)
	jump_direction.y = 0
