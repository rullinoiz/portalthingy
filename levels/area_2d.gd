extends Area2D



func _on_body_entered(body: PhysicsBody2D) -> void:
	get_tree().change_scene_to_file("res://levels/ending.tscn")
	pass # Replace with function body.
