extends Node

@export var tileMapRendererPath: NodePath 
var tileMapRenderer

const CHUNK_GAP = 1

const CHUNKS_COUNT_WIDTH = 2
const CHUNKS_COUNT_HEIGHT = 2

const CHUNK_WIDTH = 20
const CHUNK_HEIGHT = 20

var worldMap = []

var horizontalStiches = []  
var verticalStiches = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	Tiles.initialize() # Loading tiles
	Rules.initialize() # Map rules to index based system
	
	_getChunkRenderer()
	
	_clearWorldMap()
	_initializeEmptyWorldMap()
	
	# generation
	_generateStitchingEdges()
	_calculateWFCForWorldMap()
	
	# rendering
	_renderWFCGrid()
	_rednerStiches()

func _clearWorldMap() -> void:
	worldMap = []

func _getChunkRenderer() -> bool:
	tileMapRenderer = get_node(tileMapRendererPath)

	if not tileMapRenderer:
		print("Missing map generator")
		return false
	
	return true
	

func _initializeEmptyWorldMap() -> void:
	for x in range(CHUNKS_COUNT_WIDTH):
		var column = []
		for y in range(CHUNKS_COUNT_HEIGHT):
			column.append(null)
		worldMap.append(column)	

func _generateStitchingEdges():
	const horizontalStichWidth = CHUNK_WIDTH * CHUNKS_COUNT_WIDTH + (CHUNKS_COUNT_WIDTH-1) 
	const verticalStichHeigth = CHUNK_HEIGHT * CHUNKS_COUNT_HEIGHT + (CHUNKS_COUNT_HEIGHT-1) 
	
	# horizontal stitches
	for i in range(CHUNKS_COUNT_HEIGHT - 1):
		var edge = WFC.new(horizontalStichWidth , 1)
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

		var column = edge.calculateWFC()
		verticalStiches.append(column)
		

		

func _calculateWFCForWorldMap() -> void:
	for x in range(CHUNKS_COUNT_WIDTH):
		for y in range(CHUNKS_COUNT_HEIGHT):
			var chunk = WFC.new(CHUNK_WIDTH, CHUNK_HEIGHT)
			
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
					collapsedTileAbove._notifyNeighbors()
				
				if y > 0:
					var collapsedTileBelow = horizontalRowAbove[x * CHUNK_WIDTH + x + i][0]
					collapsedTileBelow.neighbors["bottom"]  = chunk.gridMatrix[i][0]
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
					collapsedTileRight._notifyNeighbors()
				
				if x > 0:
					var collapsedTileLeft = verticalRowLeft[0][y * CHUNK_HEIGHT + y + i]
					collapsedTileLeft.neighbors["right"]  = chunk.gridMatrix[0][i]
					collapsedTileLeft._notifyNeighbors()
					
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

func _on_regen_button_pressed() -> void:
	tileMapRenderer.clearMap()
	
	_clearWorldMap()
	_initializeEmptyWorldMap()
	_calculateWFCForWorldMap()
	_renderWFCGrid()
	_rednerStiches() 
