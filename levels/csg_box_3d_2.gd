extends CSGBox3D

@export var resources: Array[StandardMaterial3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_world_3d_map_changed(id: int) -> void:
	material = resources[id]
