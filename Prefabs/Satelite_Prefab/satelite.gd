extends Node2D

var SatSprite = null
func _ready() -> void:
	SatSprite = $StaticBody2D/SateliteSprite
	SatSprite.play("Idle")
