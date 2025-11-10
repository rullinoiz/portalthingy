class_name GameWorld3D extends Node3D

@export var slicedMap: LevelSlice
@export var player: Player
@export var camera: Camera3D
@export var cameraPivot: Node3D

var currentMap: NewGridMap
var currentRotation := Vector3i(0, 0, 1)
var currentSlice: Array[Array]
var mapId := 0

var tilesScene: PackedScene = preload("res://assets/tiles.tscn")
var tiles: Array[MeshInstance3D]
var rotating: bool = false

signal map_changed(id: int)
signal map_rotated(v: Vector3i)

signal new_slice(slice: Array[Array])

func next_level() -> void:
	mapId += 1
	
	if mapId == 3:
		get_tree().change_scene_to_file("res://levels/rooftop.tscn")
		return
	
	load_map(mapId)

func get_pos(grid_pos: Vector3i) -> Vector3:
	var result := (currentMap.cell_size * (Vector3(grid_pos) + Vector3(0.5, 0.5, 0.5)) + currentMap.transform.origin)
	if abs(currentRotation.x) == 1:
		result.x = 0
	elif abs(currentRotation.y) == 1:
		result.y = 2
	elif abs(currentRotation.z) == 1:
		result.z = 0
	return result

func load_map(id: int) -> void:
	var scene: NewGridMap = load("res://levels/level" + str(id) + ".tscn").instantiate()
	if currentMap:
		currentMap.queue_free()
		
	currentRotation = Vector3(0, 0, 1)
	
	add_child(scene)
	currentMap = scene
	
	player.position = currentMap.spawn.global_position * Vector3(1, 1, 0)
	player.velocity = Vector3(0, 0, 0)
	
	currentSlice = currentMap.get_slice(currentRotation)
	create_slice(currentRotation)
	
	currentMap.visible = false
	map_changed.emit(id)

func create_slice(r: Vector3i) -> void:
	new_slice.emit(currentSlice)
	slicedMap.free_children()
	
	for y: Array in currentSlice:
		for xNullable in y:
			if not xNullable: continue
			var x: Vector3i = xNullable
			var mesh := currentMap.get_cell_item(x)
			var meshTransform := currentMap.get_cell_item_basis(x)
			var tile := tiles[mesh].duplicate(true)
			
			tile.position = get_pos(x)
			tile.set_meta("grid_pos", x)
			tile.transform.basis = meshTransform
			
			if currentRotation.x == 1 or currentRotation.x == -1:
				tile.position.x = 0
			elif currentRotation.y == 1 or currentRotation.y == -1:
				tile.position.y = 0
			elif currentRotation.z == 1 or currentRotation.z == -1:
				tile.position.z = 0
			
			slicedMap.add_child(tile)

func rotate_map(r: Vector3i, pos: Vector3, tween: bool = true) -> void:
	currentRotation = r
	map_rotated.emit(r)
	print(pos)
	
	var tweenVector: Vector3
	
	if r.x == 1:
		tweenVector = Vector3(0, 90, 0)
		pos.x = 0
		pos.y = player.position.y
	elif r.x == -1:
		tweenVector = Vector3(0, -90, 0)
		pos.x = 0
		pos.y = player.position.y
	elif r.y == 1:
		tweenVector = Vector3(-90, 0, 0)
		pos.y = 2
	elif r.y == -1:
		tweenVector = Vector3(90, 0, 0)
		pos.y = 2
	elif r.z == 1:
		tweenVector = Vector3(0, 0, 0)
		pos.z = 0
		pos.y = player.position.y
	elif r.z == -1:
		tweenVector = Vector3(0, 180, 0)
		pos.z = 0
		pos.y = player.position.y
	
	var newPos := get_pos(pos)
	newPos.y = player.position.y
	player.position = newPos
	currentSlice = currentMap.get_slice(currentRotation)
	create_slice(r)
	
	if tween:
		slicedMap.visible = false
		rotating = true
		var rotateTween := get_tree().create_tween()
		rotateTween.tween_property(cameraPivot, "rotation_degrees", tweenVector, 0.5)
		currentMap.visible = true
		rotateTween.tween_callback(func() -> void: 
			currentMap.visible = false
			rotating = false
			slicedMap.visible = true
		)
	else:
		cameraPivot.rotation_degrees = tweenVector
	
	player.sprite.rotation_degrees = Vector3.ZERO
	if abs(r.x) == 1:
		player.sprite.axis = Vector3.Axis.AXIS_X
	elif abs(r.z) == 1:
		player.sprite.axis = Vector3.Axis.AXIS_Z


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var p := tilesScene.instantiate()
	
	for child in p.get_children():
		child.owner = null
		tiles.append(child)
	
	load_map(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
