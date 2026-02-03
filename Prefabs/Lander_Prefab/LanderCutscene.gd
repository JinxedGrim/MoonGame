extends CharacterBody2D

enum AnimationMode
{	
	Flying = 0,
	Idle = 1,
	LadderOut = 3
}

# Gravity will pull the rocket down
@export var MAX_DESCENT_SPEED := 120.0
@export var LANDING_DESCENT_SPEED := 30.0
@export var THRUST_RESPONSE := 6.0
var CurrSlowDown = 0

var IsLanding: bool = false
var AnimMode: AnimationMode = AnimationMode.Idle

func _updateAnimation() -> void:
	var sprite = $LanderSprite  # shorthand for get_node("AnimatedSprite2D")
	
	if AnimMode == AnimationMode.Idle:
		sprite.play("Idle")
	elif AnimMode == AnimationMode.Flying:
		sprite.play("Flying")
	else:
		sprite.play("LadderOut")


func _physics_process(delta: float) -> void:
	var updateAnimation = false
	
	if IsLanding:
		# Apply gravity only if not yet on the floor
		if not is_on_floor():
			velocity += (get_gravity() * delta)
			
			# desired descent rate
			var targetSpeed := LANDING_DESCENT_SPEED

			# smooth thrust response
			velocity.y = lerp(
				velocity.y,
				targetSpeed,
				THRUST_RESPONSE * delta
			)

			velocity.y = min(velocity.y, MAX_DESCENT_SPEED)

			
			#print("Velocity Y: ", velocity.y)
			#print("CurrSlowDown: ", CurrSlowDown)
						
			if AnimMode == AnimationMode.Idle:
				updateAnimation = true
				AnimMode = AnimationMode.Flying	
		else:
			print("Lander Landed")
			velocity.y = 0

			IsLanding = false
			
			if AnimMode == AnimationMode.Flying:
				updateAnimation = true
				AnimMode = AnimationMode.Idle
					
	if updateAnimation:
		_updateAnimation()
	# Move the rocket
	move_and_slide()
