extends Node2D
#this script  should contain some game logic and some 

# this will run once everything else is loaded im gonna do terrain generation here 
# but ideally we use await / maybe generate from another small scene (display a loading splash

# these are all in game units
const LevelWidth = 50
const LevelHeight = 5
const TileScale = 5.0

var TileTexture: Texture2D

func _GenerateTiles() -> void:
	# original texture size in pixels
	var tex_size = TileTexture.get_size()
	
	for x in range(LevelWidth):
		for y in range(LevelHeight):
			var block = Sprite2D.new()
			block.texture = TileTexture
			block.position = Vector2(x * TileScale, y * TileScale)
			block.scale = Vector2(TileScale / tex_size.x, TileScale / tex_size.y)
			add_child(block)

func _ready() -> void:
	TileTexture = load("res://Assets/Tiles/Tile.png")
	_GenerateTiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
