class_name Player extends CharacterBody3D

const SPEED = 4
const JUMP_VELOCITY = 7

func _physics_process(delta: float) -> void:
	if Global.world3d.rotating: return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("rotate_right"):
		var raycast := PhysicsRayQueryParameters3D.new()
		raycast.from = position + Vector3(0, 0, 0)
		raycast.to = position - Vector3(0, 1, 0)
		raycast.exclude = [self]
		
		var currentRotation := Global.world3d.currentRotation
		if currentRotation.z == 1:
			currentRotation = Vector3i(1, 0, 0)
		elif abs(currentRotation.x) == 1:
			currentRotation = Vector3i(0, 0, 1)
		
		var results := get_world_3d().direct_space_state.intersect_ray(raycast)
		if not results.is_empty():
			var collider = results.collider
			if collider:
				var pos := Vector3((collider as Node3D).get_parent().get_meta("grid_pos"))
				Global.world3d.rotate_map(currentRotation, pos)

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var direction: Vector3
	var rot := Global.world3d.currentRotation
	
	if abs(rot.x) == 1:
		direction = Vector3(0, 0, input_dir.x) * -rot.x
	elif abs(rot.y) == 1:
		direction = Vector3(input_dir.x, 0, input_dir.y) * rot.y
	elif abs(rot.z) == 1:
		direction = Vector3(input_dir.x, 0, 0) * rot.z
	
	if direction:
		direction *= transform.basis
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if position.x > 30:
		Global.world3d.next_level()

	move_and_slide()
