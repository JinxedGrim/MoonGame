extends Node2D

var SatSprite = null
func _ready() -> void:
	SatSprite = $StaticBody2D/SateliteSprite
	SatSprite.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
