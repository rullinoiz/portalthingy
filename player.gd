class_name Player extends CharacterBody3D

const SPEED = 4
const JUMP_VELOCITY = 7

var last_slice: Array[Array]

var canRotate: bool = true
var rotatePosition: Vector3

func _process(delta: float) -> void:
	if Global.world3d.rotating: return
	
	if not last_slice:
		if Global.world3d:
			if Global.world3d.currentMap:
				last_slice = Global.world3d.currentMap.get_slice(Vector3(1, 0, 0))
			else:
				return
		else:
			return
	
	var raycast := PhysicsRayQueryParameters3D.new()
	raycast.from = position + Vector3(0, 0, 0)
	raycast.to = position - Vector3(0, 1, 0)
	raycast.exclude = [self]
	
	var results := get_world_3d().direct_space_state.intersect_ray(raycast)
	if not results.is_empty():
		var collider = results.collider
		if collider:
			var pos := Vector3i((collider as Node3D).get_parent().get_meta("grid_pos"))
			var newPos := Global.world3d.currentMap.normalize(Vector3i(pos + Vector3i(0, 1, 0)))
			
			if abs(Global.world3d.currentRotation.x) == 1:
				canRotate = last_slice[newPos.y][newPos.x] == null
			elif abs(Global.world3d.currentRotation.z) == 1:
				canRotate = last_slice[newPos.y][newPos.z] == null
			
			rotatePosition = pos
		else:
			canRotate = false
	else:
		canRotate = false

func _physics_process(delta: float) -> void:
	if Global.world3d.rotating: return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if canRotate and Input.is_action_just_pressed("rotate_right"):
		var currentRotation := Global.world3d.currentRotation
		if currentRotation.z == 1:
			currentRotation = Vector3i(1, 0, 0)
		elif abs(currentRotation.x) == 1:
			currentRotation = Vector3i(0, 0, 1)
			
		Global.world3d.rotate_map(currentRotation, rotatePosition)

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
	
	if position.y < -5:
		Global.world3d.load_map(Global.world3d.mapId)

	move_and_slide()

func _on_world_3d_map_rotated(rot: Vector3i) -> void:
	if abs(rot.x) == 1:
		last_slice = Global.world3d.currentMap.get_slice(Vector3(0, 0, 1))
	elif abs(rot.y) == 1:
		pass
	elif abs(rot.z) == 1:
		last_slice = Global.world3d.currentMap.get_slice(Vector3(1, 0, 0))


func _on_world_3d_map_changed(id: int) -> void:
	if not Global.world3d: return
	last_slice = Global.world3d.currentMap.get_slice(Vector3(1, 0, 0))
