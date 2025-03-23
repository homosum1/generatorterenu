extends Node

@export var tileMapRendererPath: NodePath 
var tileMapRenderer

const CHUNKS_COUNT_WIDTH = 2
const CHUNKS_COUNT_HEIGHT = 2

const CHUNK_WIDTH = 20
const CHUNK_HEIGHT = 20

var worldMap = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	Tiles.initialize() # Loading tiles
	Rules.initialize() # Map rules to index based system
	
	_getChunkRenderer()
	
	_clearWorldMap()
	_initializeEmptyWorldMap()
	_calculateWFCForWorldMap()
	_renderWFCGrid()

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

func _calculateWFCForWorldMap() -> void:
	for x in range(CHUNKS_COUNT_WIDTH):
		for y in range(CHUNKS_COUNT_HEIGHT):
			var chunk = WFC.new(CHUNK_WIDTH, CHUNK_HEIGHT)
			var calculatedWFC = chunk.calculateWFC()
			worldMap[x][y] = calculatedWFC

func _renderWFCGrid() -> void:
	for x in range(CHUNKS_COUNT_WIDTH):
		for y in range(CHUNKS_COUNT_HEIGHT):
			var offset = Vector2i(x * CHUNK_WIDTH, y * CHUNK_HEIGHT)
			tileMapRenderer.renderWFCGrid(worldMap[x][y], offset)
	

func _on_regen_button_pressed() -> void:
	_clearWorldMap()
	_initializeEmptyWorldMap()
	_calculateWFCForWorldMap()
	_renderWFCGrid()
