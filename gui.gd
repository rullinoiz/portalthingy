extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Global.world3d: return
	
	if Global.world3d.player.canRotate:
		$NinePatchRect/TextureButton.modulate = Color("ffffff")
	else:
		$NinePatchRect/TextureButton.modulate = Color("0e0e0e")
		
	

func _on_texture_button_pressed() -> void:
	Input.action_press("rotate_right")
