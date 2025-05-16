extends TileMapLayer

@export var chunk_renderer_path: NodePath
@export var hills_generator_path: NodePath

var chunk_renderer
var hills_generator
var shadow_generator

var underground_map_wfc = null

var finalMapWidth = -1;
var finalMapHeigth = -1;

var noise := FastNoiseLite.new()

func _ready():
	chunk_renderer = get_node(chunk_renderer_path)
	if not chunk_renderer:
		push_error("mountain generator - ChunkRenderer not found!")
		return
		
	hills_generator = get_node(hills_generator_path)
	if not hills_generator:
		push_error("hills generator - hills generator not found!")
		return
	
func generate_water():
	finalMapWidth = chunk_renderer.total_width
	finalMapHeigth = chunk_renderer.total_height

	# initialize height map
	underground_map_wfc = WFC.new(finalMapWidth , finalMapHeigth, "water")
	
	if GlobalsSingleton.debug_settings.get_is_underground_rendered():
		# generate terrain
		generate_initial_sketch()
		
		add_final_states()
		#remove_possible_state()
					 		
		var generated_matrix = underground_map_wfc.calculateWFC()
		underground_map_wfc._printGridStateAsNums()
	else:
		var emptyTileIndex = Tiles.getIndex("empty-wall")
		for x in range(underground_map_wfc.GRID_WIDTH):
			for y in range(underground_map_wfc.GRID_HEIGHT):
				underground_map_wfc.gridMatrix[x][y].collapsedState = emptyTileIndex
	
	# render terrain
	render_underground()


func generate_initial_sketch():
	var waterTileIndex = Tiles.getIndex("water")
	
	# noise params
	noise.seed = hills_generator.noise_seed
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = GlobalsSingleton.debug_settings.get_hills_frequency()
	noise.fractal_octaves = 4
	noise.fractal_gain = 0.5
	
	var threshold =  GlobalsSingleton.debug_settings.get_underground_height_threshold()
	
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):

			var height = (noise.get_noise_2d(x, y) + 1.0) / 2.0
			if height < threshold:
				underground_map_wfc.gridMatrix[x][y].collapseTo(waterTileIndex)

func remove_possible_state():
	var waterTileIndex = Tiles.getIndex("water")
	
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):
			if(underground_map_wfc.gridMatrix[x][y].collapsedState == -1):
				underground_map_wfc.gridMatrix[x][y].possibleStates[waterTileIndex] = false

func add_final_states():
	var waterTileIndex = Tiles.getIndex("water")
	var dirtTileIndex = Tiles.getIndex("dirt")

	var tiles_to_collapse = []

	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):
			var tile = underground_map_wfc.gridMatrix[x][y]

			if tile.collapsedState != -1:
				continue 

			var is_adjacent_to_shape = false
			var is_diagonal_to_wall = false

			# cardinal neighbors
			for offset in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
				var nx = x + offset.x
				var ny = y + offset.y
				if nx >= 0 and ny >= 0 and nx < finalMapWidth and ny < finalMapHeigth:
					var neighbor = underground_map_wfc.gridMatrix[nx][ny]
					if neighbor.collapsedState != -1:
						is_adjacent_to_shape = true
						break
			
			# diagonal neighbors
			for offset in [Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(-1, -1)]:
				var nx = x + offset.x
				var ny = y + offset.y
				if nx >= 0 and ny >= 0 and nx < finalMapWidth and ny < finalMapHeigth:
					var neighbor = underground_map_wfc.gridMatrix[nx][ny]
					if neighbor.collapsedState == waterTileIndex:
						is_diagonal_to_wall = true
						break

			if not is_adjacent_to_shape and not is_diagonal_to_wall:
				tiles_to_collapse.append(Vector2(x, y))

	for coordinates in tiles_to_collapse:
		underground_map_wfc.gridMatrix[coordinates.x][coordinates.y].collapseTo(dirtTileIndex)

	
func render_underground():
	clear()
		
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):
			var tile_id = underground_map_wfc.gridMatrix[x][y].collapsedState
			if tile_id != -1:
				var tile_x = tile_id % 20
				var tile_y = tile_id / 20
				#print("RENDERING: " + str(tile_x) + ", " + str(tile_y))
				set_cell(Vector2i(x, y), 0, Vector2i(tile_x, tile_y))
