class_name Tile
extends Object

var entropy = -1 # number of possible outcomes
var collapsedState = -1 # storing collapsed state if collapse() was executed
var possibleStates = [] # array of all possible states

var neighbors = {} # dictionary of 8 neighbors

func _init():
	var possibleTilesCount = Tiles.tiles.size()
	
	for i in range(possibleTilesCount):
		possibleStates.append(true)
		
	entropy = possibleTilesCount

func collapse() -> void:
	var potentialIndexes = []
	
	for i in range(possibleStates.size()):
		if possibleStates[i]:
			potentialIndexes.append(i)
	
	if potentialIndexes.size() > 0:
		var randomIndex = randi() % potentialIndexes.size() 
		
		collapsedState = potentialIndexes[randomIndex]
		entropy = 1
		
		possibleStates.clear()  
		# notify neighbors about collapse
		_notifyNeighbors()
		

func _notifyNeighbors():
	for direction in neighbors.keys():
		neighbors[direction].onNeighborCollapse(collapsedState, direction)

# reduce tile entropy on neighbor collapse		
func onNeighborCollapse(collapsedNeighborState: int, direction: String) -> bool:
	var valid_neighbors = getPossibleNeighbors(collapsedNeighborState, direction)
	var changed = false

	for i in range(possibleStates.size()):
		if possibleStates[i] and not i in valid_neighbors:
			possibleStates[i] = false
			changed = true
			
	if changed:
		entropy = possibleStates.count(true)
	
	return changed


func getPossibleNeighbors(collapsedNeighborState: int, direction: String) -> Array:
	var possibleNeighbors = []

	for i in range(Tiles.tiles.size()):	
		if Rules.isPossibleNeighbor(collapsedNeighborState, i, direction):
			possibleNeighbors.append(i) 
	
	return possibleNeighbors


	
