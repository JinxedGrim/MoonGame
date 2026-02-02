extends Node2D

const LevelWidth = 100   # Longer level for more fun
const LevelHeight = 4   # Longer level for more fun
const TileScale = 10
var hasSpawned = false
var TileTexture: Texture2D
var SatScene := preload("res://Scenes/Satelite/Satelite.tscn")


func _ready() -> void:
	TileTexture = load("res://Assets/Tiles/Tile_1.png")
	GenerateTestLevel()
	var landerPrefab = $LanderPrefab  # shorthand for get_node("AnimatedSprite2D")
	var lander = landerPrefab.get_node("LunarLander")
	lander.IsLanding = true

func _process(delta: float) -> void:
	var landerPrefab = $LanderPrefab  # shorthand for get_node("AnimatedSprite2D")
	var lander = landerPrefab.get_node("LunarLander")
	var player = $CharacterBody2D  # shorthand for get_node("AnimatedSprite2D")
	
	if lander.IsLanding == false:
		lander.LadderOut = true
		if not hasSpawned:
			player.visible = true;
			hasSpawned = true

func _spawnTile(x, y, scale, textureToUse):
	var tex_size = textureToUse.get_size()
	var tile = StaticBody2D.new()
	var tileSprite = Sprite2D.new()
	tileSprite.texture = TileTexture
	tileSprite.position = Vector2(TileScale / 2, TileScale / 2)
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
	var y_pos = y * TileScale             
	tile.position = Vector2(x_pos, y_pos)
	
	add_child(tile)


func GenerateTestLevel() -> void:
	var tex_size = TileTexture.get_size()
	for x in range(LevelWidth):
		for y in range(LevelHeight): 
			
			if y == 0 and x == LevelWidth - 1:
				_spawnTile(x, y, TileScale, TileTexture)
				var sat = SatScene.instantiate()
				sat.position = Vector2(x*TileScale,(y-1)*TileScale)
				add_child(sat)
				continue

			_spawnTile(x, y, TileScale, TileTexture)


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
			var y_pos = TileScale - (current_step * TileScale) + (y * TileScale)
			tile.position = Vector2(x_pos, y_pos)
			
			add_child(tile)
