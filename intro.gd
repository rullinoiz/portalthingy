extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#dialogue lines
var dialogue = [
	{"text": "- How are you feeling today, Rene?", "bg": "therapist"},
	{"text": "- I think I’m fine. But thinking doesn’t make it true, does it?", "bg": "rene"},
	{"text": "- It’s a start. You’ve said before that you feel detached. From yourself, from the world.", "bg": "therapist"},
	{"text": "- Detached implies there’s something to detach from. I’m not sure that part exists anymore.", "bg": "rene"},
	{"text": "- That’s why you’re here. You need to see things from another perspective.", "bg": "therapist"},
	{"text": "- Perspective is just a trick of the eye. Tilt your head, and the truth moves with it.", "bg": "rene"},
	{"text": "- Not if you anchor it. These pills should help.", "bg": "therapist"},
	{"text": "- You think they’ll fix what’s real?", "bg": "rene"},
	{"text": "- I think they’ll show you what’s real.", "bg": "therapist"},
	{"text": "- That’s the problem. Every time I see, I trust it less.", "bg": "rene"},
	{"text": "- Then maybe don’t trust what you see. Trust that you see.", "bg": "therapist"},
	{"text": "- Cogito, ergo sum.", "bg": "rene"},
	{"text": "- Exactly. Take them when you’re ready.", "bg": "therapist"}
]

@export var char_delay = 0.03   # seconds per character
@export var line_delay = 1.5    # pause after each line

var current_line = 0
var char_index = 0
var full_text = ""
var typing = false
var current_clip: AudioStreamPlayer = null  # store the line's audio clip

@onready var label = $textbox/text
@onready var voice_therapist = $voicetherapist
@onready var voice_rene = $voicerene
@onready var therapist_bg = $therapist
@onready var rene_bg = $rene
@onready var fade = $fade
@onready var act_label = $act_label

@onready var char_timer = Timer.new()
@onready var line_timer = Timer.new()

func _ready():
	# add timers to the scene
	add_child(char_timer)
	add_child(line_timer)
	char_timer.one_shot = true
	line_timer.one_shot = true
	char_timer.connect("timeout", Callable(self, "_on_char_timer_timeout"))
	line_timer.connect("timeout", Callable(self, "_on_line_timer_timeout"))
	
	#fade
	fade.visible = false
	fade.color = Color.BLACK
	fade.modulate.a = 0.0
	
	#label
	act_label.visible = false
	act_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	act_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# start first line
	show_next_line()
	
func show_next_line():
	if current_line >= dialogue.size():
		end_cutscene()
		return
		
	# switch backgrounds
	var bg_name = dialogue[current_line]["bg"]
	therapist_bg.visible = bg_name == "therapist"
	rene_bg.visible = bg_name == "rene"
	
	# prepare text
	full_text = dialogue[current_line]["text"]
	char_index = 0
	label.text = ""
	typing = true
	
	# select voice clip for this line
	if bg_name == "therapist":
		current_clip = voice_therapist
	elif bg_name == "rene":
		current_clip = voice_rene
	else:
		current_clip = null
	
	current_line += 1
	
	# start typewriter
	char_timer.start(char_delay)
	
func _on_char_timer_timeout():
	if char_index < full_text.length():
		label.text += full_text[char_index]
		char_index += 1
		
		# play short voice blip if not already playing
		if current_clip and not current_clip.playing:
			current_clip.play()
		
		# restart timer for next character
		char_timer.start(char_delay)
	else:
		typing = false
		
		# stop voice immediately at end of line
		if current_clip and current_clip.playing:
			current_clip.stop()
		
		# wait before next line
		line_timer.start(line_delay)
		
func _on_line_timer_timeout():
	show_next_line()

func end_cutscene():
	# stop any audio still playing
	if current_clip and current_clip.playing:
		current_clip.stop()
	
	# start fade to black
	fade.visible = true
	fade.modulate.a = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 1.5) # 1.5s fade
	await tween.finished
	
	# play pill sound
	$pilluse.play()
	await get_tree().create_timer(0.5).timeout
	
	# show act label and play titledrop
	$act_label.text = "[ACT I. COGITO]"
	$act_label.visible = true
	
	# wait a bit before switching scenes
	await get_tree().create_timer(2.5).timeout
	
	get_tree().change_scene_to_file("res://levels/root.tscn")
