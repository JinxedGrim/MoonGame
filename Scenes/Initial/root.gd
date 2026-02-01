extends Node2D

# these are all in game units
const LevelWidth = 50
const LevelHeight = 5
const TileScale = 5.0

var TileTexture: Texture2D

# this will run once everything else is loaded im gonna do terrain generation here 
# but ideally we use await / maybe generate from another small scene (display a loading splash
func _generateTiles() -> void:
	# original texture size in pixels
	var textureSize = TileTexture.get_size()
	
	for x in range(LevelWidth):
		for y in range(LevelHeight):
			var tile = StaticBody2D.new()
			
			var tileSprite = Sprite2D.new()
			tileSprite.texture = TileTexture
			tileSprite.position = Vector2(0, 0)
			tileSprite.scale = Vector2(TileScale / textureSize.x, TileScale / textureSize.y)
			tile.add_child(tileSprite)
			
			var collider = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			shape.extents = (textureSize * TileScale) / 2  # half-width/height
			collider.shape = shape
			collider.position = Vector2(0, 0)
			tile.add_child(collider)

			tile.position = Vector2(x * TileScale, y * TileScale)
			
			add_child(tile)

func _ready() -> void:
	TileTexture = load("res://Assets/Tiles/Tile_2.png")
	_generateTiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
