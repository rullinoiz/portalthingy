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

signal map_changed(id: int)
signal map_rotated(v: Vector3i)

signal new_slice(slice: Array[Array])

func load_map(id: int) -> void:
	var scene: NewGridMap = load("res://levels/level" + str(id) + ".tscn").instantiate()
	if currentMap:
		currentMap.queue_free()
	
	add_child(scene)
	currentMap = scene
	
	player.position = currentMap.spawn.position
	player.velocity = Vector3(0, 0, 0)
	
	currentSlice = currentMap.get_slice(currentRotation)
	create_slice(currentRotation)
	
	currentMap.visible = false

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
			
			tile.position = currentMap.cell_size * Vector3(x)
			tile.set_meta("grid_pos", x)
			tile.transform.basis = meshTransform
			
			if currentRotation.x == 1 or currentRotation.x == -1:
				tile.position.x = 0
			elif currentRotation.y == 1 or currentRotation.y == -1:
				tile.position.y = 0
			elif currentRotation.z == 1 or currentRotation.z == -1:
				tile.position.z = 0
			
			slicedMap.add_child(tile)

func rotate_map(r: Vector3i, pos: Vector3) -> void:
	currentRotation = r
	print(pos)
	
	if r.x == 1:
		cameraPivot.rotation_degrees.y = 90
		cameraPivot.rotation_degrees.x = 0
		pos.x = 0
		pos.y = player.position.y
	elif r.x == -1:
		cameraPivot.rotation_degrees.y = -90
		cameraPivot.rotation_degrees.x = 0
		pos.x = 0
		pos.y = player.position.y
	elif r.y == 1:
		cameraPivot.rotation_degrees.x = -90
		cameraPivot.rotation_degrees.y = 0
		pos.y = 2
	elif r.y == -1:
		cameraPivot.rotation_degrees.x = 90
		cameraPivot.rotation_degrees.y = 0
		pos.y = 2
	elif r.z == 1:
		cameraPivot.rotation_degrees.y = 0
		cameraPivot.rotation_degrees.x = 0
		pos.z = 0
		pos.y = player.position.y
	elif r.z == -1:
		cameraPivot.rotation_degrees.y = 180
		cameraPivot.rotation_degrees.x = 0
		pos.z = 0
		pos.y = player.position.y
	
	player.position = pos
	currentSlice = currentMap.get_slice(currentRotation)
	create_slice(r)
	
	pass

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
