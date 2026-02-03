extends CharacterBody2D

enum AnimationMode
{	
	Flying = 0,
	Idle = 1,
	LadderOut = 3
}

# Gravity will pull the rocket down
@export var INITIAL_GRAVITY_FACTOR = 1
@export var INITIAL_SLOW_DOWN = 5
@export var SLOWDOWN_FACTOR = 6
var CurrSlowDown = 0

var LadderOut: bool = false
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
			CurrSlowDown = SLOWDOWN_FACTOR * exp(-CurrSlowDown + INITIAL_SLOW_DOWN)
			velocity += (get_gravity() * delta)
			velocity.y = clamp(velocity.y, 0, INF)
			#print("Velocity Y: ", velocity.y)
			#print("CurrSlowDown: ", CurrSlowDown)
						
			if AnimMode == AnimationMode.Idle:
				updateAnimation = true
				AnimMode = AnimationMode.Flying	
		else:
			print("Lander Landed")
			velocity.y = 0

			IsLanding = false
			
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
