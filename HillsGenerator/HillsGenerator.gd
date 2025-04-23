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
	
	# render terrain
	render_mountains()

#
#func initialize_grid():
	#height_map = []
	#for x in range(finalMapWidth):
		#var column = []
		#for y in range(finalMapHeigth):
			#column.append(Tile.new(x, y, "wall"))
		#height_map.append(column)	
#
#func assign_neighbors():
	#for x in range(finalMapWidth):
		#for y in range (finalMapHeigth):
			#var processedTile = height_map[x][y]
			#
			#if x > 0:
				#processedTile.neighbors["left"] = height_map[x-1][y]
			#if x < finalMapWidth -1:
				#processedTile.neighbors["right"] = height_map[x + 1][y]
			#if y > 0:
				#processedTile.neighbors["top"] = height_map[x][y - 1]
			#if y < finalMapHeigth - 1:
				#processedTile.neighbors["bottom"] = height_map[x][y + 1]

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
			if height > 0.8:
				height_map_wfc.gridMatrix[x][y].collapseTo(wallTile)
			
func render_mountains():
	clear()
		
	for x in range(finalMapWidth):
		for y in range(finalMapHeigth):
			if(height_map_wfc.gridMatrix[x][y].collapsedState != -1):
				const CLIFF_ROW_NUM := 5
				var indexToPrint = height_map_wfc.gridMatrix[x][y].collapsedState - CLIFF_ROW_NUM * 20
				
				#print("pos: (", x, ", ", y, ") render cell: (", CLIFF_ROW_NUM-1, ", ", indexToPrint, ")")
				set_cell(Vector2i(x, y), 1, Vector2i(indexToPrint, CLIFF_ROW_NUM-1))
