extends CharacterBody2D

enum AnimationMode
{	
	Flying = 0,
	Idle = 1,
	LadderOut = 3
}

# Gravity will pull the rocket down
const SPEED = 50.0
var IsLanding: bool = false
var LadderOut: bool = false
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
			velocity += get_gravity() * delta
			
			if AnimMode == AnimationMode.Idle:
				updateAnimation = true
				AnimMode = AnimationMode.Flying	
		else:
			velocity.y = 0
			IsLanding = false
			LadderOut = true
			if AnimMode != AnimationMode.Idle || AnimMode != AnimationMode.LadderOut:
				updateAnimation = true
				
				if LadderOut:
					AnimMode = AnimationMode.LadderOut
				else:
					AnimMode = AnimationMode.Idle
					
	if updateAnimation:
		_updateAnimation()
	# Move the rocket
	move_and_slide()
