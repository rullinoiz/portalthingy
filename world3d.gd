extends Node3D

@export var gridContainer: GridContainer
@export var gridMap: NewGridMap
@export var rectScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var slice := gridMap.get_slice(Vector3i(0, -1, 0))
	gridContainer.columns = slice[0].size()
	
	for x: Array in slice:
		for y in x:
			var child := rectScene.instantiate() as ColorRect
			child.color = Color.WHITE if y else Color.BLACK
			gridContainer.add_child(child)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
