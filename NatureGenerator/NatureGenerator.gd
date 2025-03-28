extends TileMapLayer

@export var chunk_renderer_path: NodePath

const GRASS_TILE_ID := 0  # grass ID in tileSet
const SMALL_GRASS_TILE_ID := 1 


@export var grass_density := 0.4

var chunk_renderer
var noise := FastNoiseLite.new()

# Twoja dodatkowa mapa trawy: true = jest trawa, false = brak
var natureMap: Array[Array] = []
var final_map = []

var finalMapWidth
var finalMapHeigth

func _ready():
	chunk_renderer = get_node(chunk_renderer_path)
	if not chunk_renderer:
		push_error("nature generator - ChunkRenderer not found!")
		return
		

func generate_nature():
	final_map = chunk_renderer.finalWorldMap
	if final_map.is_empty():
		push_warning("nature generator - Final world map is empty")
		return

	# initialize natureMap
	finalMapWidth = final_map.size()	
	finalMapHeigth = final_map[0].size()
	
	
	for x in range(finalMapWidth):
		natureMap.append([])
		for y in range(finalMapHeigth):
			natureMap[x].append(-1)
	
	_generate_grass()
	_generate_small_grass()
	_renderNatureMap()

func _generate_grass():	
	clear()
	if chunk_renderer == null:
		push_error("nature generator - ChunkRenderer not found")
		return

	noise.frequency = 0.1
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()

	# grass generating
	for x in range(final_map.size()):
		for y in range(final_map[x].size()):
			var tile = final_map[x][y]
			if tile == null:
				continue

			if tile.collapsedState == Tiles.getIndex("grass"):
				var n = noise.get_noise_2d(x, y)
				if n > grass_density:
					natureMap[x][y] = GRASS_TILE_ID

func _generate_small_grass():
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):
			# leve positions where grass is already planted
			if natureMap[x][y] != -1:
				continue
			
			# leave positions without grass
			var tile = final_map[x][y]
			if tile == null:
				continue
			if tile.collapsedState != Tiles.getIndex("grass"):
				continue
			
			var nearby_grass = 0
			var check_radius = 2

			# calculate nearby tall grasses
			for dx in range(-check_radius, check_radius + 1):
				for dy in range(-check_radius, check_radius + 1):
					var nx = x + dx
					var ny = y + dy
					if nx >= 0 and ny >= 0 and nx < finalMapWidth and ny < finalMapHeigth:
						if natureMap[nx][ny] == GRASS_TILE_ID:
							nearby_grass += 1

			# calculate probability of small grass
			if nearby_grass > 0:
				var chance = clamp(nearby_grass / 8.0, 0.1, 0.8)
				if randf() < chance:
					natureMap[x][y] = SMALL_GRASS_TILE_ID


func _renderNatureMap():
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):
			var tileID = natureMap[x][y]
			set_cell(Vector2i(x, y), 0, Vector2i(tileID, 0))
