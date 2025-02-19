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

func gridInit() -> void:
	for x in range(GRID_WIDTH):
		var gridColumn = []
		for y in range(GRID_HEIGHT):
			gridColumn.append(Tile.new())
		
		gridMatrix.append(gridColumn)

func findTileWithMinEntropy() -> Array:
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
