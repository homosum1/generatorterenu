class_name Tile
extends Object

var entropy = -1 # number of possible outcomes
var collapsedState = -1 # storing collapsed state if collapse() was executed
var possibleStates = [] # array of all possible states

var neighbors = {} # dictionary of 8 neighbors

var position = Vector2(-1, -1)

func _init(x: int, y: int):
	position = Vector2(x, y)
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
		
		if Globals.DEBUG_MODE:
			print("↳ Tile at: ", position, " collapsed to: ", Tiles.getName(collapsedState), " (", collapsedState, ")")
		
		possibleStates.clear()  
		# notify neighbors about collapse
		_notifyNeighbors()
	else:
		print("No potential states:", possibleStates, " at: ", position)
		push_error("Stopping execution from Object class")
		
		assert(false)

func _notifyNeighbors():
	for direction in neighbors.keys():
		neighbors[direction].onNeighborCollapse(collapsedState, direction)

# reduce tile entropy on neighbor collapse		
func onNeighborCollapse(collapsedNeighborState: int, direction: String) -> bool:
	if collapsedState != -1:
		return false
		
	var valid_neighbors = getPossibleNeighbors(collapsedNeighborState, direction)
	

	if Globals.DEBUG_MODE:
		print("   ↳ ", position, " neighbor update. Affecting rule: ", Tiles.getName(collapsedNeighborState), " in direction: ", direction)
		var validNeighborsNames = valid_neighbors.map(func(index): return Tiles.getName(index))
		print("    valid: ", validNeighborsNames)
	
		
	var changed = false

	for i in range(possibleStates.size()):
		if possibleStates[i] and not i in valid_neighbors:
			if Globals.DEBUG_MODE:
				print("    - removing state:", Tiles.getName(i))
			possibleStates[i] = false
			changed = true
			
	if changed:
		entropy = possibleStates.count(true)
		if Globals.DEBUG_MODE:
			print("    new entropy for: ", position, " - entropy:", entropy)
	
	return changed


func onNeighborUpdate(possibleStatesFromNeighbor: Array, direction: String) -> bool:
	# skip if state already collapsed
	if collapsedState != -1:
		return false
		
	var valid_neighbors = []
	
	for neighbor_state in possibleStatesFromNeighbor:
		valid_neighbors.append_array(getPossibleNeighbors(neighbor_state, direction))

	var changed = false

	
	if Globals.DEBUG_MODE:
		print("   ↳ Tile at", position, "update from neighbor in direction:", direction)
		#var validNeighborsNames = valid_neighbors.map(func(index): return Tiles.getName(index))
		#print("    Valid neighbors (combined):", validNeighborsNames)

	for i in range(possibleStates.size()):
		if possibleStates[i] and not i in valid_neighbors:
			if Globals.DEBUG_MODE:
				print("    - Removing state:", Tiles.getName(i), "from Tile at", position)
			possibleStates[i] = false
			changed = true

	if changed:
		entropy = possibleStates.count(true) 
		if Globals.DEBUG_MODE:
			print("    New entropy for Tile at", position, ":", entropy)

	return changed

func getPossibleNeighbors(collapsedNeighborState: int, direction: String) -> Array:
	var possibleNeighbors = []

	for i in range(Tiles.tiles.size()):	
		if Rules.isPossibleNeighbor(collapsedNeighborState, i, direction):
			possibleNeighbors.append(i) 
	
	return possibleNeighbors


	
