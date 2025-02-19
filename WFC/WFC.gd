extends Node

const GRID_WIDTH = 10
const GRID_HEIGHT = 10

var gridMatrix = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
				
			#if (x > 0) and (y > 0):
				#processedTile.neighbors["top_left"] = gridMatrix[x - 1][y - 1]
			#if (x < GRID_WIDTH - 1) and (y > 0):
				#processedTile.neighbors["top_right"] = gridMatrix[x + 1][y - 1]
			#if (x > 0) and (y < GRID_HEIGHT - 1):
				#processedTile.neighbors["bottom_left"] = gridMatrix[x - 1][y + 1]
			#if (x < GRID_WIDTH - 1) and (y < GRID_HEIGHT - 1):
				#processedTile.neighbors["bottom_right"] = gridMatrix[x + 1][y + 1]
						
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
