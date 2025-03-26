extends TileMapLayer

@export var chunk_renderer_path: NodePath

@export var grass_tile_id := 0  # grass ID in tileSet
@export var grass_density := 0.4


var chunk_renderer
var noise := FastNoiseLite.new()

func _ready():
	chunk_renderer = get_node(chunk_renderer_path)

	if not chunk_renderer:
		push_error("nature generator -  ChunkRenderer not found!")
		return
	
	noise.frequency = 0.1
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX

func generate_grass():
	if chunk_renderer == null:
		push_error("nature generator - ChunkRenderer not found")
		return

	var final_map = chunk_renderer.finalWorldMap
	if final_map.is_empty():
		push_warning("nature generator - Final world map is empty")
		return

	clear()
	noise.seed = randi()

	for x in range(final_map.size()):
		for y in range(final_map[x].size()):
			var tile = final_map[x][y]
			if tile == null:
				continue

			if tile.collapsedState == Tiles.getIndex("grass"):
				var n = noise.get_noise_2d(x, y)
				if n > grass_density:
					set_cell(Vector2i(x, y), 0, Vector2i(grass_tile_id, 0))
