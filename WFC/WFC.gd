class_name WFC

var GRID_WIDTH = 0
var GRID_HEIGHT = 0
var gridMatrix: Array[Array]  = []


func _init(grid_width: int, grid_height: int) -> void:
	self.GRID_WIDTH = grid_width
	self.GRID_HEIGHT = grid_height
	_gridInit()  # Initialize grid for WFC

func calculateWFC() -> Array[Array]:	
	_runWFC()  # Start WFC algorithm
	
	return gridMatrix

func _gridInit() -> void:
	# create tiles
	for x in range(GRID_WIDTH):
		var gridColumn = []
		for y in range(GRID_HEIGHT):
			gridColumn.append(Tile.new(x, y))
			
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
				
	if Globals.DEBUG_MODE:
		_printGridDebug()

func _printGridDebug():
	print("\n------- Initialized grid data -------")
	for y in range(GRID_HEIGHT):
		var row = ""
		for x in range(GRID_WIDTH):
			row += "[" + str(gridMatrix[x][y]) + "] "
		print(row)

func _findTileWithMinEntropy() -> Array:
	var minEntropy = Tiles.tiles.size() + 1
	var bestCandidates =  []
	
	for x in range(GRID_WIDTH):   
		for y in range(GRID_HEIGHT):
			var consideredTile = gridMatrix[x][y]
			var consideredEntropy = consideredTile.entropy
			
			#if consideredEntropy > 1:
			if consideredTile.collapsedState == -1: # for testing 
				if consideredEntropy < minEntropy:
					minEntropy = consideredEntropy
					bestCandidates = [[x,y]]
				elif consideredEntropy == minEntropy:
					bestCandidates.append([x,y])
	
	# select randomly one from selected min entropy tiles
	if bestCandidates.size() > 0:
		var randomIndex = randi() % bestCandidates.size()
		if Globals.DEBUG_MODE:
			print("\nselected min etropy tile: ", bestCandidates[randomIndex])
		return bestCandidates[randomIndex]
	else:
		if Globals.DEBUG_MODE:
			print("empty min entropy")
		return []	


func _collapseTile(x: int, y: int) -> void:
	var tile = gridMatrix[x][y]

	if tile.collapsedState != -1:
		# tile is already collapsed
		if Globals.DEBUG_MODE:
			print("tile:", [x, y], "is already collapsed:", Tiles.getName(tile.collapsedState))
		return  
		
	tile.collapse() 
	
func _propagateWave():
	if Globals.DEBUG_MODE:
		print("\nPROPAGATE WAVE\n")
	
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
				var old_entropy = neighbor.entropy
				
				
				# if current tile is collapsed
				if tile.collapsedState != -1:
					if neighbor.onNeighborCollapse(tile.collapsedState, direction):
						if neighbor.entropy > 1:
							if Globals.DEBUG_MODE:
								print("- adding tile: ",  neighbor.position, " to the queue")
							queue.append(neighbor)
				# else if current tile isn't collapsed
				else:
					var tilePossibleStates = []
					for i in range(tile.possibleStates.size()):
						if tile.possibleStates[i]:
							tilePossibleStates.append(i)

					if neighbor.onNeighborUpdate(tilePossibleStates, direction):
						if neighbor.entropy > 1:
							if Globals.DEBUG_MODE:
								print("- adding tile: ",  neighbor.position, " to the queue")
							queue.append(neighbor)
				

func _runWFC():
	const MAX_ITERATIONS = 10000 # MAKE IT SMALLER AFTER TESTS
	var iterations = 0
	while true and (iterations <= MAX_ITERATIONS):
		if Globals.DEBUG_MODE:
			print("\nWFC ITERATION\n")
			_printEntropyMap()
		
		
			
		var pos = _findTileWithMinEntropy()
		
		if pos.is_empty():
			# stop algorithm when all tiles are collapsed
			break 
		
		_collapseTile(pos[0], pos[1])
		_propagateWave()
		
		iterations+=1

		if Globals.DEBUG_MODE:		
			print("Iterations: ", iterations)
		
		#_printGridState()
	
	if Globals.DEBUG_MODE:
		print("\nWFC ENDED")
	
		_printEntropyMap()
		_printGridStateAsNums()

func _printGridState():
	print("\n--- Grid State ---")
	for y in range(GRID_HEIGHT):
		var row = ""
		for x in range(GRID_WIDTH):
			var tile = gridMatrix[x][y]
			var tile_name = Tiles.getName(tile.collapsedState) if tile.entropy == 1 else "?"
			row += tile_name + "\t"
		print(row)
		
func _printGridStateAsNums():
	print("\n--- Grid State ---")
	for y in range(GRID_HEIGHT):
		var row = ""
		for x in range(GRID_WIDTH):
			var tile = gridMatrix[x][y]
			row += str(tile.collapsedState) + "\t"
		print(row)

func _printEntropyMap():
	print("\n\n--- Entropy Map ---")
	for y in range(GRID_HEIGHT):
		var row = ""
		for x in range(GRID_WIDTH):
			var tile = gridMatrix[x][y]
			row += str(tile.entropy) + "\t"
		print(row)
