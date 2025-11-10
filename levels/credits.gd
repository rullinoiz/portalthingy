extends Node2D

var beginMoving: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	beginMoving = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if beginMoving and position.y < 318:
		position.y += 150 * delta
	pass
