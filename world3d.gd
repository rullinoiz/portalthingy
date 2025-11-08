class_name GameWorld3D extends Node3D

@export var currentMap: NewGridMap
@export var slicedMap: Node3D

var mapId = 0

signal map_changed()
signal map_rotated(v: Vector3i)

func begin_map() -> void:
	
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
