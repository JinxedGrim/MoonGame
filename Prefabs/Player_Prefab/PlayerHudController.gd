extends CanvasLayer

# --- 1. THE PIECES ---
@onready var oxygen_bar: ProgressBar = get_node_or_null("OxygenBar")
@onready var oxygen_label: Label = get_node_or_null("OxygenLabel")
@onready var marker: Sprite2D = get_node_or_null("ObjectiveMarker") # The visual icon for the goal

# Path to find your player and the goal
@onready var player: Node2D = get_node_or_null("../LunarLander") 
@onready var goal: Node2D = get_node_or_null("../Objective") 

# Delta-based animation variables
var current_oxygen: float = 100.0
var target_oxygen: float = 100.0
var marker_smooth_speed: float = 5.0
var oxygen_transition_speed: float = 2.0

func _process(delta: float):
	# Smooth oxygen transitions
	if abs(current_oxygen - target_oxygen) > 0.1:
		current_oxygen = move_toward(current_oxygen, target_oxygen, oxygen_transition_speed * delta)
		_update_oxygen_display(current_oxygen)
	
	# If we have a goal, move the marker to it
	if goal and marker:
		_run_marker_logic(delta)

# --- 2. THE MARKER LOGIC (The "Waypoint") ---
func _run_marker_logic(delta: float):
	# Find where the goal is on your actual monitor screen
	var target_pos = goal.get_global_transform_with_canvas().get_origin()
	
	# Get the screen size so we know where the edges are
	var screen_size = get_viewport().get_visible_rect().size
	var margin = 50 # Keep the icon 50 pixels away from the very edge
	
	# THE CLAMP: This forces the marker to stay inside the screen box
	# It says: "If the goal is off-screen, stay at the edge"
	var final_x = clamp(target_pos.x, margin, screen_size.x - margin)
	var final_y = clamp(target_pos.y, margin, screen_size.y - margin)
	var target_position = Vector2(final_x, final_y)
	
	# Smooth marker movement with delta
	marker.position = marker.position.move_toward(target_position, marker_smooth_speed * delta * 60)

# --- 3. THE OXYGEN API ---
# The player script calls this to update the screen
func update_ui(amount: float):
	target_oxygen = amount  # Set target, actual update happens in _process

func _update_oxygen_display(amount: float):
	if oxygen_bar:
		oxygen_bar.value = amount
	if oxygen_label:
		oxygen_label.text = "Oxygen: " + str(int(amount)) + "%"
	
	# Simple Color Switch with smooth transitions
	if oxygen_bar:
		var target_color: Color
		if amount > 60:
			target_color = Color.GREEN  # Good
		elif amount > 25:
			target_color = Color.YELLOW # Careful
		else:
			target_color = Color.RED    # Danger
		
		# Smooth color transition
		oxygen_bar.modulate = oxygen_bar.modulate.lerp(target_color, 0.1)
