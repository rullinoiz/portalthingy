class_name GameWorld3D extends Node3D

@export var slicedMap: LevelSlice
@export var player: Player

var currentMap: NewGridMap
var currentRotation := Vector3i(0, 0, 1)
var currentSlice: Array[Array]
var mapId := 0

var tilesScene: PackedScene = preload("res://assets/tiles.tscn")
var tiles: Array[MeshInstance3D]

signal map_changed()
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
			tile.transform.basis = meshTransform
			
			if currentRotation.x == 1 or currentRotation.x == -1:
				tile.position.x = 0
			elif currentRotation.y == 1 or currentRotation.y == -1:
				tile.position.y = 0
			elif currentRotation.z == 1 or currentRotation.z == -1:
				tile.position.z = 0
			
			slicedMap.add_child(tile)
	
	currentMap.visible = false

func rotate_map(rotation: Vector3i) -> void:
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var p := tilesScene.instantiate()
	
	for child in p.get_children():
		child.owner = null
		tiles.append(child)
	
	p.queue_free()
	
	load_map(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
