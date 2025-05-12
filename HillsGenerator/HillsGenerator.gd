extends TileMapLayer

@export var chunk_renderer_path: NodePath

var chunk_renderer
var shadow_generator

#var height_map = []

var height_map_wfc = null

var finalMapWidth = -1;
var finalMapHeigth = -1;

var noise := FastNoiseLite.new()

func _ready():
	chunk_renderer = get_node(chunk_renderer_path)
	if not chunk_renderer:
		push_error("mountain generator - ChunkRenderer not found!")
		return
	
func generate_mountains():
	if chunk_renderer.finalWorldMap.is_empty():
		push_warning("mountain generator - WorldMapIsEmpty")
		return
	
	finalMapWidth = chunk_renderer.finalWorldMap.size()
	finalMapHeigth = chunk_renderer.finalWorldMap[0].size()

	# initialize height map
	height_map_wfc = WFC.new(finalMapWidth , finalMapHeigth, "wall")
	
	# generate terrain
	generate_initial_sketch()
	add_final_states()
	#remove_possible_state()
	
	Rules.test_neighbor_rule_symmetry()

	height_map_wfc._printGridStateAsNums()
	
	# // wyzeruj siatkę wokol generowanej gory 		
	var generated_matrix = height_map_wfc.calculateWFC()

	
	# render terrain
	render_mountains()


func generate_initial_sketch():
	var wallTile = Tiles.getIndex("dirt-wall")
	
	# noise params
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.007
	noise.fractal_octaves = 4
	noise.fractal_gain = 0.5
	
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):

			var height = (noise.get_noise_2d(x, y) + 1.0) / 2.0
			if height > 0.7:
				height_map_wfc.gridMatrix[x][y].collapseTo(wallTile)

func remove_possible_state():
	var wallTileIndex = Tiles.getIndex("dirt-wall")
	
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):
			if(height_map_wfc.gridMatrix[x][y].collapsedState == -1):
				height_map_wfc.gridMatrix[x][y].possibleStates[wallTileIndex] = false

func add_final_states():
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
			var is_under_wall = false

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
			
			# 3 tiles under the wall
			for offset_y in range(1, 5): # should be 4
				var ny = y - offset_y
				if ny >= 0:
					var neighbor_above = height_map_wfc.gridMatrix[x][ny]
					if neighbor_above.collapsedState == wallTileIndex:
						is_under_wall = true
						break

			if not is_adjacent_to_shape and not is_diagonal_to_wall and not is_under_wall:
				tiles_to_collapse.append(Vector2(x, y))

	for coordinates in tiles_to_collapse:
		height_map_wfc.gridMatrix[coordinates.x][coordinates.y].collapseTo(emptyTileIndex)

	
func render_mountains():
	clear()
		
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):
			if(height_map_wfc.gridMatrix[x][y].collapsedState != -1):
				const CLIFF_ROW_NUM := 5
				var indexToPrint = height_map_wfc.gridMatrix[x][y].collapsedState - CLIFF_ROW_NUM * 20
				
				#print("pos: (", x, ", ", y, ") render cell: (", CLIFF_ROW_NUM-1, ", ", indexToPrint, ")")
				set_cell(Vector2i(x, y), 1, Vector2i(indexToPrint, CLIFF_ROW_NUM-1))
