extends Node2D

enum WarblerState 
{
	Idle = 0,
	PlayerInSight = 1,
	IdleNoPlayer = 2,
}

var State: WarblerState = WarblerState.Idle 
var targetCoords: Vector2 = Vector2(0, 0);

func _canSeePlayer(player: Node2D):
	var spaceState = get_world_2d().direct_space_state
	
	var from = global_position
	var to = player.global_position
	
	var result = spaceState.intersect_ray(from, to, [self, player])
	
	if !result.empty():
		return false
	
	return true

func _ready() -> void:
	add_to_group("Enemy")
	State = WarblerState.Idle
	$Body/Sprite.play("Idle")

func _process(delta: float) -> void:
	if(_canSeePlayer())
