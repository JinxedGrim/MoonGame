extends Node2D

var Pos = Vector2(0, 0)
var speed: float = 5.0 # units/s

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	# WASD / arrow keys
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("d"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("a"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("s"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("w"):
		input_vector.y -= 1

	input_vector = input_vector.normalized()  # keep diagonal movement from being faster

	var velocity = input_vector * speed
	
	# Apply movement to the character
	global_position += velocity
