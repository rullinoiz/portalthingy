extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -350.0

@onready var _animated_sprite = $AnimatedSprite2D

#func _process(_delta):
	#if Input.is_action_pressed("move_left"):
		#_animated_sprite.play("walk")
	#else:
		#_animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		_animated_sprite.play("walk")
		velocity.x = direction * SPEED
	else:
		_animated_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
