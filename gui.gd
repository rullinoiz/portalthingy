extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not Global.world3d: return
	
	if Global.world3d.player.canRotate:
		$NinePatchRect/TextureButton.modulate = Color("ffffff")
	else:
		$NinePatchRect/TextureButton.modulate = Color("242424ff")
		
	

func _on_texture_button_pressed() -> void:
	if not Global.world3d: return
	
	if Global.world3d.player.canRotate:
	
		Input.action_press("rotate_right")
		await get_tree().process_frame
		$PillUse.play()
	
