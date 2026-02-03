extends Node2D

@export var LevelWidth = 50 
@export var LevelHeight = 1
@export var TileScale = 7 # in px but preferably in units!!
@export var SatScene := preload("res://Prefabs/Satelite_Prefab/Satelite.tscn")
@export var TilePrefab := preload("res://Prefabs/Tile_Prefab/TileScene.tscn")
var landerPrefab = null
var lander = null
var hasSpawned = false
var TileTexture: Texture2D = preload("res://Assets/Tiles/MoonRocks.PNG")


var trackPlayer = false
var trackLander = true
var hasPlayedLanderExit = false

func _ready() -> void:
	landerPrefab = $LanderPrefab  # shorthand for get_node("AnimatedSprite2D")
	lander = landerPrefab.get_node("LunarLander")
	GenerateTestLevel()
	lander.IsLanding = true

func _process(delta: float) -> void:
	var player = $PlayerBody  # shorthand for get_node("AnimatedSprite2D")
	
	if lander.IsLanding == false:
		$Camera.position = player.position
		if not hasSpawned:
			player.visible = true;
			hasSpawned = true
			landerPrefab.playLanderExit(player)
	else:
		$Camera.position = lander.position
		
		#sky doesnt match  but this is nice
		$Camera.zoom = Vector2(10, 10)


func _spawnTile(x, y, textureToUse: Texture2D):
	
	var tile = TilePrefab.instantiate()
	tile.position = Vector2(x * TileScale,y)
	tile.scale = Vector2(TileScale / textureToUse.get_size().x, TileScale / textureToUse.get_size().y)
	add_child(tile)
	
	#var tex_size = textureToUse.get_size()
	#var tile = StaticBody2D.new()
	#var tileSprite = Sprite2D.new()
	#tileSprite.texture = TileTexture
	#tileSprite.position = Vector2(TileScale / 2, TileScale / 2)
	#tileSprite.scale = Vector2(TileScale / tex_size.x, TileScale / tex_size.y)
	#tile.add_child(tileSprite)
	#
	## Physics
	#var collider = CollisionShape2D.new()
	#var shape = RectangleShape2D.new()
	#shape.size = Vector2(TileScale, TileScale)
	#collider.shape = shape
	#collider.position = Vector2(TileScale / 2, TileScale / 2)
	#tile.add_child(collider)
#
	## Placement
	#var x_pos = x * TileScale
	#var y_pos = y * TileScale             
	#tile.position = Vector2(x_pos, y_pos)
	#
	#add_child(tile)


func GenerateTestLevel() -> void:
	for x in range(LevelWidth):
		for y in range(LevelHeight): 
			if y == 0 and x == LevelWidth - 1:
				var sat = SatScene.instantiate()
				sat.position = Vector2(x*TileScale,(y-1)*TileScale)
				add_child(sat)

			_spawnTile(x, y, TileTexture)


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
