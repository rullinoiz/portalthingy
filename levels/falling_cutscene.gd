extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$fallingCutscene.play()
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_falling_cutscene_finished() -> void:
	get_tree().change_scene_to_file("res://levels/ending.tscn")
	pass # Replace with function body.
