extends Node2D

const LevelWidth = 100   # Longer level for more fun
const TileScale = 64.0   

var TileTexture: Texture2D

func _ready() -> void:
	TileTexture = load("res://Assets/Tiles/Tile_2.png")
	
	# THE CAMERA: Set up the lens so we can see the start
	var cam = Camera2D.new()
	cam.enabled = true
	add_child(cam)
	cam.make_current()
	cam.position = Vector2(600, 200) 
	
	_generateRandomLevel()

func _generateRandomLevel() -> void:
	var current_step = 0
	
	for x in range(LevelWidth):
		# 1. THE HOLE CHANCE
		# Roll a 10-sided die. If it's 1, skip this column (creates a gap/hole)
		if x > 5 and randi() % 10 == 0:
			continue # This skips all the code below and moves to the next 'x'
			
		# 2. THE RANDOM HEIGHT
		# Every 3 blocks, we might change height drastically
		if x % 3 == 0:
			# Randomly choose: -2, -1, 0, 1, or 2 blocks high
			current_step += randi_range(-2, 2)
			
		# 3. BUILDING THE COLUMN
		for y in range(4):
			var tile = StaticBody2D.new()
			
			# Visuals
			var tileSprite = Sprite2D.new()
			if TileTexture != null:
				tileSprite.texture = TileTexture
			else:
				tileSprite.texture = PlaceholderTexture2D.new()
				tileSprite.texture.size = Vector2(64, 64)
			
			tileSprite.centered = false
			tileSprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			var tex_size = tileSprite.texture.get_size()
			tileSprite.scale = Vector2(TileScale / tex_size.x, TileScale / tex_size.y)
			tile.add_child(tileSprite)
			
			# Physics
			var collider = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(TileScale, TileScale)
			collider.shape = shape
			collider.position = Vector2(TileScale / 2, TileScale / 2)
			tile.add_child(collider)

			# Placement
			var x_pos = x * TileScale
			var y_pos = 300 - (current_step * TileScale) + (y * TileScale)
			tile.position = Vector2(x_pos, y_pos)
			
			add_child(tile)
