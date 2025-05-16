extends TileMapLayer

@export var chunk_renderer_path: NodePath

var chunk_renderer
var shadow_generator

var height_map_wfc = null

var finalMapWidth = -1;
var finalMapHeigth = -1;

var noise_seed = -1
var noise := FastNoiseLite.new()


var replacement_rules = [	
#	// CORNERS 
	{
		"pattern": [
			["dirt-wall_corner_bottom-right", "dirt-wall_bottom"]
		],
		"size": Vector2i(2, 1),
		"replacements": [
			{ "offset": Vector2i(1, 1), "set_tile": "top-dirt-wall_left" },
			{ "offset": Vector2i(1, 2), "set_tile": "down-dirt-wall_left" }
		]
	},
	{
		"pattern": [
			["dirt-wall_bottom", "dirt-wall_corner_bottom-left"]
		],
		"size": Vector2i(2, 1),
		"replacements": [
			{ "offset": Vector2i(0, 1), "set_tile": "top-dirt-wall_right" },
			{ "offset": Vector2i(0, 2), "set_tile": "down-dirt-wall_right" }
		]
	},
	
#	// SOLO EDGES
	{
		"pattern": [
			["dirt-wall_bottom-left"]
		],
		"size": Vector2i(1, 1),
		"replacements": [
			{ "offset": Vector2i(0, 1), "set_tile": "top-dirt-wall_left" },
			{ "offset": Vector2i(0, 2), "set_tile": "down-dirt-wall_left" }
		]
	},
	{
		"pattern": [
			["dirt-wall_bottom-right"]
		],
		"size": Vector2i(1, 1),
		"replacements": [
			{ "offset": Vector2i(0, 1), "set_tile": "top-dirt-wall_right" },
			{ "offset": Vector2i(0, 2), "set_tile": "down-dirt-wall_right" }
		]
	},
	
	#	// EMPTY NEIGHBOURS
	{
		"pattern": [
			["dirt-wall_bottom"]
		],
		"size": Vector2i(1, 1),
		"replacements": [
			{ "offset": Vector2i(0, 1), "set_tile": "top-dirt-wall_mid" },
			{ "offset": Vector2i(0, 2), "set_tile": "down-dirt-wall_mid" }
		]
	},
]

func _matches_pattern_at(x: int, y: int, pattern: Array) -> bool:
	for dy in range(len(pattern)):
		for dx in range(len(pattern[dy])):
			var expected_tile_name = pattern[dy][dx]
			if expected_tile_name == null:
				continue
			var px = x + dx
			var py = y + dy
			if px >= finalMapWidth or py >= finalMapHeigth:
				return false
			var actual_index = height_map_wfc.gridMatrix[px][py].collapsedState
			var expected_index = Tiles.getIndex(expected_tile_name)
			
			#print("act: " + str(actual_index) + " fact: " + str(expected_index))
			
			#if actual_index == expected_index:
				#print("matched index!")
			
			if actual_index != expected_index:
				return false
	return true

func _apply_tile_replacement_patterns():
	for rule in replacement_rules:
		var pattern = rule["pattern"]
		var size = rule["size"]
		var replacements = rule["replacements"]

		for x in range(finalMapWidth - size.x + 1):
			for y in range(finalMapHeigth - size.y + 1):
				if _matches_pattern_at(x, y, pattern):
					for rep in replacements:
						var tx = x + rep["offset"].x
						var ty = y + rep["offset"].y
						if tx >= 0 and ty >= 0 and tx < finalMapWidth and ty < finalMapHeigth:
							var tile_index = Tiles.getIndex(rep["set_tile"])
							#print("Matched pattern at:", tx, ty)
							if height_map_wfc.gridMatrix[tx][ty].collapsedState == Tiles.getIndex("empty-wall"):
								height_map_wfc.gridMatrix[tx][ty].collapsedState = tile_index


func _ready():
	chunk_renderer = get_node(chunk_renderer_path)
	if not chunk_renderer:
		push_error("mountain generator - ChunkRenderer not found!")
		return
	
func generate_mountains():
	finalMapWidth = chunk_renderer.total_width
	finalMapHeigth = chunk_renderer.total_height

	# initialize height map
	height_map_wfc = WFC.new(finalMapWidth , finalMapHeigth, "wall")
	
	if GlobalsSingleton.debug_settings.get_are_hills_rendered():
		# generate terrain
		_generate_initial_sketch()
		_add_final_states()
		#remove_possible_state()
			
		Rules.test_neighbor_rule_symmetry()
		 		
		var generated_matrix = height_map_wfc.calculateWFC()
		_apply_tile_replacement_patterns()
		#height_map_wfc._printGridStateAsNums()
	else:
		var emptyTileIndex = Tiles.getIndex("empty-wall")
		for x in range(height_map_wfc.GRID_WIDTH):
			for y in range(height_map_wfc.GRID_HEIGHT):
				height_map_wfc.gridMatrix[x][y].collapsedState = emptyTileIndex
	
	# render terrain
	_render_mountains()


func _generate_initial_sketch():
	var wallTile = Tiles.getIndex("dirt-wall")
	
	noise_seed = randi()
	
	# noise params
	noise.seed = noise_seed
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = GlobalsSingleton.debug_settings.get_hills_frequency()
	noise.fractal_octaves = 4
	noise.fractal_gain = 0.5
	
	var threshold =  GlobalsSingleton.debug_settings.get_hills_height_threshold()
	
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):

			var height = (noise.get_noise_2d(x, y) + 1.0) / 2.0
			if height > threshold:
				height_map_wfc.gridMatrix[x][y].collapseTo(wallTile)

func _remove_possible_state():
	var wallTileIndex = Tiles.getIndex("dirt-wall")
	
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):
			if(height_map_wfc.gridMatrix[x][y].collapsedState == -1):
				height_map_wfc.gridMatrix[x][y].possibleStates[wallTileIndex] = false

func _add_final_states():
	var wallTileIndex = Tiles.getIndex("dirt-wall")
	var emptyTileIndex = Tiles.getIndex("empty-wall")

	var tiles_to_collapse = []

	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):
			var tile = height_map_wfc.gridMatrix[x][y]

			if tile.collapsedState != -1:
				continue 

			var is_adjacent_to_shape = false
			var is_diagonal_to_wall = false

			# cardinal neighbors
			for offset in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
				var nx = x + offset.x
				var ny = y + offset.y
				if nx >= 0 and ny >= 0 and nx < finalMapWidth and ny < finalMapHeigth:
					var neighbor = height_map_wfc.gridMatrix[nx][ny]
					if neighbor.collapsedState != -1:
						is_adjacent_to_shape = true
						break
			
			# diagonal neighbors
			for offset in [Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(-1, -1)]:
				var nx = x + offset.x
				var ny = y + offset.y
				if nx >= 0 and ny >= 0 and nx < finalMapWidth and ny < finalMapHeigth:
					var neighbor = height_map_wfc.gridMatrix[nx][ny]
					if neighbor.collapsedState == wallTileIndex:
						is_diagonal_to_wall = true
						break

			if not is_adjacent_to_shape and not is_diagonal_to_wall:
				tiles_to_collapse.append(Vector2(x, y))

	for coordinates in tiles_to_collapse:
		height_map_wfc.gridMatrix[coordinates.x][coordinates.y].collapseTo(emptyTileIndex)

func _render_mountains():
	clear()
		
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):
			var tile_id = height_map_wfc.gridMatrix[x][y].collapsedState
			if tile_id != -1:
				var tile_x = tile_id % 20
				var tile_y = tile_id / 20
				set_cell(Vector2i(x, y), 1, Vector2i(tile_x, tile_y))


func _get_hill_state(x: int, y: int) -> int:
	if x >= 0 and y >= 0 and x < height_map_wfc.GRID_WIDTH and y < height_map_wfc.GRID_HEIGHT:
		return height_map_wfc.gridMatrix[x][y].collapsedState
	return Tiles.getIndex("empty-wall")
	
func _has_non_empty_neighbors(world_x: int, world_y: int, empty_wall_index: int) -> bool:
	for offset in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var nx = world_x + offset.x
		var ny = world_y + offset.y
		if _get_hill_state(nx, ny) != empty_wall_index:
			return true
	return false

func apply_mountain_mask_to_chunk(chunk: WFC, chunk_x: int, chunk_y: int) -> void:
	var empty_wall = Tiles.getIndex("empty-wall")
	var stone_index = Tiles.getIndex("stone")
	
	for cx in range(chunk_renderer.CHUNK_WIDTH):
		for cy in range(chunk_renderer.CHUNK_HEIGHT):
			var world_x = chunk_x * (chunk_renderer.CHUNK_WIDTH + chunk_renderer.CHUNK_GAP) + cx
			var world_y = chunk_y * (chunk_renderer.CHUNK_HEIGHT + chunk_renderer.CHUNK_GAP) + cy

			var hill_cell = height_map_wfc.gridMatrix[world_x][world_y]
			if hill_cell.collapsedState != empty_wall or _has_non_empty_neighbors(world_x, world_y, empty_wall):
				chunk.gridMatrix[cx][cy].collapseTo(stone_index)

func apply_mountain_mask_to_horizontal_stitch(row_index: int, edge: WFC) -> void:
	var empty_wall = Tiles.getIndex("empty-wall")
	var stone_index = Tiles.getIndex("stone")

	for x in range(edge.GRID_WIDTH):
		var world_x = x
		var world_y = (row_index + 1) * chunk_renderer.CHUNK_HEIGHT + row_index

		var hill_cell = height_map_wfc.gridMatrix[world_x][world_y]
		if hill_cell.collapsedState != empty_wall or _has_non_empty_neighbors(world_x, world_y, empty_wall):
			edge.gridMatrix[x][0].collapseTo(stone_index)

func apply_mountain_mask_to_vertical_stitch(col_index: int, edge: WFC) -> void:
	var empty_wall = Tiles.getIndex("empty-wall")
	var stone_index = Tiles.getIndex("stone")

	for y in range(edge.GRID_HEIGHT):
		var world_x = (col_index + 1) * chunk_renderer.CHUNK_WIDTH + col_index
		var world_y = y

		var hill_cell = height_map_wfc.gridMatrix[world_x][world_y]
		if hill_cell.collapsedState != empty_wall or _has_non_empty_neighbors(world_x, world_y, empty_wall):
			if edge.gridMatrix[0][y].collapsedState == -1:
				edge.gridMatrix[0][y].collapseTo(stone_index)
