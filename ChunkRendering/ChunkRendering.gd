extends Node

@export var tileMapRendererPath: NodePath 
@export var natureMapRendererPath: NodePath
@export var hillMapRendererPath: NodePath

var tileMapRenderer
var natureMapRenderer
var hillMapRenderer

const CHUNK_GAP = 1

const CHUNKS_COUNT_WIDTH = 3
const CHUNKS_COUNT_HEIGHT = 3

const CHUNK_WIDTH = 10
const CHUNK_HEIGHT = 10

var worldMap = []
var finalWorldMap = []

var horizontalStiches = []  
var verticalStiches = []

var total_width = CHUNK_WIDTH * CHUNKS_COUNT_WIDTH + (CHUNKS_COUNT_WIDTH - 1)
var total_height = CHUNK_HEIGHT * CHUNKS_COUNT_HEIGHT + (CHUNKS_COUNT_HEIGHT - 1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	Tiles.initialize() # Loading tiles
	Rules.initialize() # Map rules to index based system
	
	_getChunkRenderer()
	_getNatureRenderer()
	_getHillsGenerator()
	
	_groupedGenerationAlgorithm()
	
func _groupedGenerationAlgorithm() -> void:
	_clearWorldMap()
	_initializeEmptyWorldMap()

	# hills generation
	hillMapRenderer.generate_mountains()
		
	# generation
	if Globals.USE_STICHING:
		_generateStitchingEdges()
	_calculateWFCForWorldMap()
		
	finalWorldMap = build_combined_world_map()
	
	# post processing
	PostProcess.clean_up_edges(finalWorldMap)
	
	# rendering current
	tileMapRenderer.renderWFCGrid(finalWorldMap, Vector2i(0,0))
	
	natureMapRenderer.generate_nature()

		

func _clearWorldMap() -> void:
	horizontalStiches = []  
	verticalStiches = []
	worldMap = []
	finalWorldMap = []

func _getChunkRenderer() -> bool:
	tileMapRenderer = get_node(tileMapRendererPath)

	if not tileMapRenderer:
		print("Missing map generator")
		return false
	
	return true

func _getNatureRenderer() -> bool:
	natureMapRenderer = get_node(natureMapRendererPath)
	
	if not natureMapRenderer:
		print("Missing nature map generator")
		return false
	
	return true

func _getHillsGenerator() -> bool:
	hillMapRenderer = get_node(hillMapRendererPath)
	
	if not hillMapRenderer:
		print("Missing hill map generator")
		return false
	
	return true


func _initializeEmptyWorldMap() -> void:
	for x in range(CHUNKS_COUNT_WIDTH):
		var column = []
		for y in range(CHUNKS_COUNT_HEIGHT):
			column.append(null)
		worldMap.append(column)	


func _apply_mountain_mask_to_horizontal_stitch(row_index: int, edge: WFC) -> void:
	var empty_wall = Tiles.getIndex("empty-wall")
	var dirt_index = Tiles.getIndex("dirt")

	for x in range(edge.GRID_WIDTH):
		var world_x = x
		var world_y = (row_index + 1) * CHUNK_HEIGHT + row_index

		var hill_cell = hillMapRenderer.height_map_wfc.gridMatrix[world_x][world_y]
		if hill_cell.collapsedState != empty_wall:
			edge.gridMatrix[x][0].collapseTo(dirt_index)

func _apply_mountain_mask_to_vertical_stitch(col_index: int, edge: WFC) -> void:
	var empty_wall = Tiles.getIndex("empty-wall")
	var dirt_index = Tiles.getIndex("dirt")

	for y in range(edge.GRID_HEIGHT):
		var world_x = (col_index + 1) * CHUNK_WIDTH + col_index
		var world_y = y

		var hill_cell = hillMapRenderer.height_map_wfc.gridMatrix[world_x][world_y]
		if hill_cell.collapsedState != empty_wall:
			if edge.gridMatrix[0][y].collapsedState == -1:
				edge.gridMatrix[0][y].collapseTo(dirt_index)


func _generateStitchingEdges():
	const horizontalStichWidth = CHUNK_WIDTH * CHUNKS_COUNT_WIDTH + (CHUNKS_COUNT_WIDTH-1) 
	const verticalStichHeigth = CHUNK_HEIGHT * CHUNKS_COUNT_HEIGHT + (CHUNKS_COUNT_HEIGHT-1) 
	
	# horizontal stitches
	for i in range(CHUNKS_COUNT_HEIGHT - 1):
		var edge = WFC.new(horizontalStichWidth , 1)
		_apply_mountain_mask_to_horizontal_stitch(i, edge)
		var row = edge.calculateWFC()
		horizontalStiches.append(row)
		
	# vertical stitch 
	# add collapsed tiles from horizontal stitches to
	# vertial not yet collapsed stitches
	for x in range(CHUNKS_COUNT_WIDTH - 1):
		var edge = WFC.new(1, verticalStichHeigth)

		# Inject already collapsed intersection tiles from horizontalStitches
		for y in range(CHUNKS_COUNT_HEIGHT - 1):
			var intersectY = CHUNK_HEIGHT * (y + 1) + y  
			var intersectX = CHUNK_WIDTH * (x + 1) + x   

			
			var collapsedIndex = horizontalStiches[y][intersectX][0].collapsedState
			edge.gridMatrix[0][intersectY].collapseTo(collapsedIndex)

		_apply_mountain_mask_to_vertical_stitch(x, edge)
		var column = edge.calculateWFC()
		verticalStiches.append(column)
		

func _apply_mountain_mask_to_chunk(chunk: WFC, chunk_x: int, chunk_y: int) -> void:
	var empty_wall = Tiles.getIndex("empty-wall")
	var dirt_index = Tiles.getIndex("dirt")
	
	for cx in range(CHUNK_WIDTH):
		for cy in range(CHUNK_HEIGHT):
			var world_x = chunk_x * (CHUNK_WIDTH + CHUNK_GAP) + cx
			var world_y = chunk_y * (CHUNK_HEIGHT + CHUNK_GAP) + cy

			var hill_cell = hillMapRenderer.height_map_wfc.gridMatrix[world_x][world_y]
			if hill_cell.collapsedState != empty_wall:
				chunk.gridMatrix[cx][cy].collapseTo(dirt_index)


func _calculateWFCForWorldMap() -> void:
	for x in range(CHUNKS_COUNT_WIDTH):
		for y in range(CHUNKS_COUNT_HEIGHT):
			var chunk = WFC.new(CHUNK_WIDTH, CHUNK_HEIGHT)
			
			if Globals.USE_STICHING:
				# --- Stitching context ---
				#1. Top edge (horizontal stitching)
					
				var horizontalRowBelow = null
				var horizontalRowAbove = null
			
				if y < (CHUNKS_COUNT_HEIGHT - 1):
					horizontalRowBelow = horizontalStiches[y]
				
				if y > 0:
					horizontalRowAbove = horizontalStiches[y-1]
								
				for i in range(CHUNK_WIDTH):
					if y < (CHUNKS_COUNT_HEIGHT - 1):
						var collapsedTileAbove = horizontalRowBelow[x * CHUNK_WIDTH + x + i][0]
						collapsedTileAbove.neighbors["top"]  = chunk.gridMatrix[i][CHUNK_HEIGHT-1]
						chunk.gridMatrix[i][CHUNK_HEIGHT-1].neighbors["bottom"] = collapsedTileAbove
						collapsedTileAbove._notifyNeighbors()
					
					if y > 0:
						var collapsedTileBelow = horizontalRowAbove[x * CHUNK_WIDTH + x + i][0]
						collapsedTileBelow.neighbors["bottom"]  = chunk.gridMatrix[i][0]
						chunk.gridMatrix[i][0].neighbors["top"] = collapsedTileBelow
						collapsedTileBelow._notifyNeighbors()
						
				#2. Righ edge (vertical stitching)
				var verticalRowRight = null
				var verticalRowLeft = null
			
				if x < (CHUNKS_COUNT_WIDTH - 1):
					verticalRowRight = verticalStiches[x]
				
				if x > 0:
					verticalRowLeft = verticalStiches[x-1]
				
				for i in range(CHUNK_HEIGHT):
					if x < (CHUNKS_COUNT_WIDTH - 1):
						var collapsedTileRight = verticalRowRight[0][y * CHUNK_HEIGHT + y + i]
						collapsedTileRight.neighbors["left"]  = chunk.gridMatrix[CHUNK_WIDTH-1][i]
						chunk.gridMatrix[CHUNK_WIDTH-1][i].neighbors["right"] = collapsedTileRight
						collapsedTileRight._notifyNeighbors()
					
					if x > 0:
						var collapsedTileLeft = verticalRowLeft[0][y * CHUNK_HEIGHT + y + i]
						collapsedTileLeft.neighbors["right"]  = chunk.gridMatrix[0][i]
						chunk.gridMatrix[0][i].neighbors["left"] = collapsedTileLeft
						collapsedTileLeft._notifyNeighbors()
			
			# here fill chumnk with data from: hillMapRenderer.height_map_wfc
			_apply_mountain_mask_to_chunk(chunk, x, y)
			
			var calculatedWFC = chunk.calculateWFC()
			worldMap[x][y] = calculatedWFC


func _renderWFCGrid() -> void:
	for x in range(CHUNKS_COUNT_WIDTH):
		for y in range(CHUNKS_COUNT_HEIGHT):
			var offset = Vector2i(
				x * (CHUNK_WIDTH + CHUNK_GAP), 
				y * (CHUNK_HEIGHT + CHUNK_GAP)
			)
			#print("offset x: " + str(x) + " y: " + str(y))

			tileMapRenderer.renderWFCGrid(worldMap[x][y], offset)

func _rednerStiches() -> void:
	# render horizontal stitches
	for y in range(CHUNKS_COUNT_HEIGHT - 1):
		var offset = Vector2i(0, (y + 1) * CHUNK_HEIGHT + y * CHUNK_GAP)
		var row = horizontalStiches[y]  
		tileMapRenderer.renderWFCGrid(row, offset)
	
	# render vertical stitches
	for x in range(CHUNKS_COUNT_WIDTH - 1):
		var offset = Vector2i((x + 1) * CHUNK_WIDTH + x * CHUNK_GAP, 0)
		var column = verticalStiches[x]
		tileMapRenderer.renderWFCGrid(column, offset)


func build_combined_world_map() -> Array:
	var combined_map = []
	for x in range(total_width):
		var column = []
		for y in range(total_height):
			column.append(null)
		combined_map.append(column)

	# --- Copy chunks to final world map ---
	for chunk_x in range(CHUNKS_COUNT_WIDTH):
		for chunk_y in range(CHUNKS_COUNT_HEIGHT):
			var chunk = worldMap[chunk_x][chunk_y]
			if chunk == null:
				continue

			var base_x = chunk_x * (CHUNK_WIDTH + 1)
			var base_y = chunk_y * (CHUNK_HEIGHT + 1)

			for x in range(CHUNK_WIDTH):
				for y in range(CHUNK_HEIGHT):
					combined_map[base_x + x][base_y + y] = chunk[x][y]

	# --- Adding horizontal stitches to final world map ---
	for y in range(CHUNKS_COUNT_HEIGHT - 1):
		var row = horizontalStiches[y]
		var row_y = (y + 1) * CHUNK_HEIGHT + y

		for x in range(row.size()):
			combined_map[x][row_y] = row[x][0]

	# --- Add vertical stitches to final world map ---
	for x in range(CHUNKS_COUNT_WIDTH - 1):
		var column = verticalStiches[x]
		var column_x = (x + 1) * CHUNK_WIDTH + x

		for y in range(column[0].size()):
			combined_map[column_x][y] = column[0][y]

	# --- Assign neihbours (with deleting old ones) ---
	for x in range(total_width):
		for y in range (total_height):
			combined_map[x][y].neighbors.clear()
	
	for x in range(total_width):
		for y in range (total_height):
			var processedTile = combined_map[x][y]
			
			if x > 0:
				processedTile.neighbors["left"] = combined_map[x-1][y]
			if x < total_width -1:
				processedTile.neighbors["right"] = combined_map[x + 1][y]
			if y > 0:
				processedTile.neighbors["top"] = combined_map[x][y - 1]
			if y < total_height - 1:
				processedTile.neighbors["bottom"] = combined_map[x][y + 1]

	return combined_map

func _on_regen_button_pressed() -> void:
	tileMapRenderer.clearMap()
	_groupedGenerationAlgorithm()
