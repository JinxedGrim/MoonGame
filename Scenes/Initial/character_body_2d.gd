extends CharacterBody2D

@export var speed := 100
@export var gravity := 1200.0
@export var jump_force := -500

func _physics_process(delta):
	var input_direction = Vector2.ZERO
	# --- Horizontal movement ---
	input_direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	velocity.x = input_direction.x * speed
	# --- Jump ---
	if Input.is_action_just_pressed("Jump") and velocity.y == 0:
		print("jump was called")
		velocity.y = jump_force
	# --- Gravity ---
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # important: set to zero to register floor
	# --- Move the player ---
	# Pass Vector2.UP so CharacterBody2D knows which way is "floor"
	move_and_slide()
	# --- Debug floor detection ---
	if is_on_floor():
		print("is on floor")
	# --- Animation logic (optional) ---
	var is_walking = abs(velocity.x) > 1.0
	if is_walking:
		if velocity.x < 0:
			$AnimatedSprite2D.play("Walking")
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("Walking")
			$AnimatedSprite2D.flip_h = true 
	else:
		$AnimatedSprite2D.play("Idle")
