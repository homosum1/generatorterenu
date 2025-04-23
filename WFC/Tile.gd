class_name Tile
extends Object

var entropy = -1 # number of possible outcomes
var collapsedState = -1 # storing collapsed state if collapse() was executed
var possibleStates = [] # array of all possible states

var neighbors = {} # dictionary of 4 neighbors

var position = Vector2(-1, -1)

var grassines = GlobalsSingleton.debug_settings.get_grassines()
var earthness = GlobalsSingleton.debug_settings.get_earthness()

var tileType = "default"

const TILE_TYPE_RANGES := {
	"default": Vector2i(0, 13),
	"wall": Vector2i(100, 119)   
}

func _init(x: int, y: int, tilesType: String = "default"):
	position = Vector2(x, y)
	
	tileType = tilesType

	#new possibleStatesCount (counting for future needed space)	
	#var possibleTilesCount = Tiles.tiles.size() + 2
	var possibleTilesCount = Tiles.tiles[Tiles.tiles.size() - 1]["index"] + 1
	
	var range = TILE_TYPE_RANGES.get(tilesType, Vector2i(0, 13))

	for i in range(possibleTilesCount):
		if i >= range.x and i <= range.y:
			possibleStates.append(true)
			entropy += 1
		else:
			possibleStates.append(false)

func collapse() -> void:
	var potentialIndexes = []
	var weightedIndexes = [] 

	
	#const boostsMap = {0: 15, 1: 3, 6: 1, 7: 1, 8: 1, 9: 1}
	#const boostsMap = {0: 3, 1: 30, 6: 1, 7: 1, 8: 1, 9: 1}	
	var boostsMap = {0: grassines, 1: earthness, 6: 1, 7: 1, 8: 1, 9: 1}
	
	# miejsce na bardziej złozony system, gdzie przewaga jednego z dwoch tile'i
	# boostuje prawdopodobienstwo krawedzi dla drugiego tile'a, tak aby przeszedl
	# on w inny tile
	
	
	for i in range(possibleStates.size()):
		if possibleStates[i]:
			potentialIndexes.append(i)

	if potentialIndexes.size() == 0:
		if(entropy != -100):
			print("❌ unable to collapse, entropy: ", entropy)
			entropy = 0;
			collapsedState = 99
		
		return

	var neighborStatesCounts = {}

	for direction in neighbors.keys():
		var neighbor = neighbors[direction]
		if neighbor and (neighbor.collapsedState != -1):
			var state = neighbor.collapsedState
			# Add more "probability" if neighbour has a similar state
			neighborStatesCounts[state] = neighborStatesCounts.get(state, 0) + 1 

	for index in potentialIndexes:
		var weight = 1 
		
		# boost probability based on adjacency
		if index in neighborStatesCounts:
			#weight += log(1 + neighborStatesCounts[index]) * boostsMap.get(index, 1)
			weight += pow(boostsMap.get(index, 1), neighborStatesCounts[index])
		
		# boost probability purely on intended boost
		if boostsMap.has(index):
			var plannedBoost = boostsMap.get(index, 1)
			weight += plannedBoost

		for _i in range(weight):
			weightedIndexes.append(index)

	var randomIndex = randi() % weightedIndexes.size()
	collapsedState = weightedIndexes[randomIndex]
	entropy = 1

	if Globals.DEBUG_MODE:
		print("↳ Tile at: ", position, " collapsed to: ", Tiles.getName(collapsedState), " (", collapsedState, ") with weighted probability.")

	possibleStates.clear()  
	_notifyNeighbors()

func collapseTo(index: int):

	if not possibleStates[index]:
		
		#print(entropy)
		#print(possibleStates)
		print("failed to collapse invalid index: %d at position %s" % [index, str(position)])
		return

	collapsedState = index
	entropy = 1
	
	possibleStates.clear()  
	_notifyNeighbors()

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

	var possibleTilesCount = Tiles.tiles[Tiles.tiles.size() - 1]["index"] + 1
	
	for i in range(possibleTilesCount):	
		if Rules.isPossibleNeighbor(collapsedNeighborState, i, direction):
			possibleNeighbors.append(i) 
	
	return possibleNeighbors
	

# needs adjustments
func reset_possible_states_v2() -> void:
	for direction in neighbors.keys():
		var neighbor = neighbors[direction]
		if neighbor and (neighbor.collapsedState != -1):
			neighbor._notifyNeighbors()

func reset_possible_states() -> void:	
	var oppositeDirection = {
		"top": "bottom",
		"bottom": "top",
		"left": "right",
		"right": "left"
	}

	# update possible states based on neighbours
	for direction in neighbors.keys():
		var neighbor = neighbors[direction]
		if neighbor and (neighbor.collapsedState != -1):
			var state = neighbor.collapsedState
			var allowedStates = getPossibleNeighbors(state, oppositeDirection[direction])
			
			for i in range(possibleStates.size()):
				if possibleStates[i] and not i in allowedStates:
					possibleStates[i] = false
	
	
	entropy = possibleStates.count(true)
