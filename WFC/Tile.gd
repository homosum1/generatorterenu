class_name Tile
extends Object

var entropy = -1
var collapsedState = -1
var possibleStates = []

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
		
