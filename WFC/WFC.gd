extends Node

const GRID_WIDTH = 6
const GRID_HEIGHT = 6

var gridMatrix = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Rules.initialize() # Map rules to index based system
	#_gridInit()  # Initialize grid for WFC
	#_runWFC()  # Start WFC algorithm

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _gridInit() -> void:
	# create tiles
	for x in range(GRID_WIDTH):
		var gridColumn = []
		for y in range(GRID_HEIGHT):
			gridColumn.append(Tile.new())
			
		gridMatrix.append(gridColumn)

	# assign neighbors
	for x in range(GRID_WIDTH):
		for y in range (GRID_HEIGHT):
			var processedTile = gridMatrix[x][y]
			
			if x > 0:
				processedTile.neighbors["left"] = gridMatrix[x-1][y]
			if x < GRID_WIDTH -1:
				processedTile.neighbors["right"] = gridMatrix[x + 1][y]
			if y > 0:
				processedTile.neighbors["top"] = gridMatrix[x][y - 1]
			if y < GRID_HEIGHT - 1:
				processedTile.neighbors["bottom"] = gridMatrix[x][y + 1]
				
						
func _findTileWithMinEntropy() -> Array:
	var minEntropy = Tiles.tiles.size() + 1
	var bestCandidates =  []
	
	for x in range(GRID_WIDTH):   
		for y in range(GRID_HEIGHT):
			var consideredTile = gridMatrix[x][y]
			var consideredEntropy = consideredTile.entropy
			
			if consideredEntropy > 1:
				if consideredEntropy < minEntropy:
					minEntropy = consideredEntropy
					bestCandidates = [[x,y]]
				elif consideredEntropy == minEntropy:
					bestCandidates.append([x,y])
	
	# select randomly one from selected min entropy tiles
	if bestCandidates.size() > 0:
		var randomIndex = randi() % bestCandidates.size()
		return bestCandidates[randomIndex]
	else:
		return []	


func _collapseTile(x: int, y: int) -> void:
	var tile = gridMatrix[x][y]

	if tile.entropy <= 1:
		# tile is already collapsed
		return  

	tile.collapse() 

func _propagateWave():
	var queue = []

	# if tile is collapsed - add to queue
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			if gridMatrix[x][y].entropy == 1:
				queue.append(gridMatrix[x][y])

	# empty queue
	while queue.size() > 0:
		var tile = queue.pop_front()

		for direction in tile.neighbors.keys():
			var neighbor = tile.neighbors[direction]

			if neighbor and neighbor.entropy > 1:
				if neighbor.onNeighborCollapse(tile.collapsedState, direction):
					# add changed neighbors to queue
					queue.append(neighbor)  

func _runWFC():
	while true:
		var pos = _findTileWithMinEntropy()
		
		if pos.is_empty():
			# stop algorithm when all tiles are collapsed
			break 
		
		_collapseTile(pos[0], pos[1])
		_propagateWave()
