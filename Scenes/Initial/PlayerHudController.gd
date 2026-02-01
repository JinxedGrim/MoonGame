extends CanvasLayer

# Simple HUD that works without requiring UI elements
# Can be expanded later with actual UI components

func _ready():
	print("HUD Controller initialized - ready for UI elements when needed")

func _process(_delta):
	# Currently empty - will handle UI updates when elements are added
	pass

# Placeholder function for future oxygen system
func update_ui(amount: float):
	print("Oxygen: ", amount, "%")
	# Will update actual UI elements when they're added to the scene