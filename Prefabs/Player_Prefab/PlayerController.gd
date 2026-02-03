extends CharacterBody2D

@export var speed := 50
@export var jumpSpeed := -100

enum PlayerState
{
	NonControllable = 0,
	WalkTo = 1,
	ClimbTo = 2
}

var State: PlayerState = PlayerState.NonControllable

func _physics_process(delta):
	var inputDir = Vector2.ZERO
	inputDir.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	velocity.x = inputDir.x * speed
	
	velocity += get_gravity() * delta

	var onFloor = move_and_slide()	
	var is_walking = abs(velocity.x) > 1.0

	if Input.is_action_just_pressed("Jump") and onFloor:
		velocity.y += jumpSpeed  

	move_and_slide()

	#TODO 
	# Add gun anims and cracked / not cracked
	if not onFloor:
		$Sprite.play("Falling")
		$Sprite.flip_h = velocity.x > 0
	elif is_walking:
		$Sprite.play("Walking")
		$Sprite.flip_h = velocity.x > 0
	else:
		$Sprite.play("Idle")
