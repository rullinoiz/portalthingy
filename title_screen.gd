extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not bgmplayer.playing:
		bgmplayer.play() # plays music across whole game
	pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass	

func _on_play_pressed():
	$click.play()
	get_tree().change_scene_to_file("res://intro.tscn")

func _on_credits_pressed():
	$click.play()
	get_tree().change_scene_to_file("res://credits.tscn")
