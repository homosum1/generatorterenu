class_name Rules
extends Object

const adjacencyRules = {
	
	# ----------- GRASS TILES -----------
	
	"grass": {
		"left": [
			"grass", 
			"grass-dirt_left",
			"grass-dirt_corner_top-left",
			"grass-dirt_corner_bottom-left"
		],
		"right": [
			"grass", 
			"grass-dirt_right",
			"grass-dirt_corner_top-right",
			"grass-dirt_corner_bottom-right"
		],
		"top": [
			"grass", 
			"grass-dirt_top",
			"grass-dirt_corner_top-left",
			"grass-dirt_corner_top-right",
		],
		"bottom": [
			"grass", 
			"grass-dirt_bottom",
			"grass-dirt_corner_bottom-left",
			"grass-dirt_corner_bottom-right"
		]
	},
	"dirt": {
		"left": [
			"dirt",
			"grass-dirt_right",
			"grass-dirt_bottom-right",
			"grass-dirt_top-right",
		],
		"right": [
			"dirt",
			"grass-dirt_left",
			"grass-dirt_bottom-left",
			"grass-dirt_top-left",
		],
		"top": [
			"dirt",
			"grass-dirt_bottom",
			"grass-dirt_bottom-left",
			"grass-dirt_bottom-right",
		],
		"bottom": [
			"dirt",
			"grass-dirt_top",
			"grass-dirt_top-left",
			"grass-dirt_top-right",
		]
	},	
	"grass-dirt_top": {
		"left": [
			"grass-dirt_top", 
			"grass-dirt_top-left",
			"grass-dirt_corner_top-right"	
		],
		"right": [
			"grass-dirt_top", 
			"grass-dirt_top-right",
			"grass-dirt_corner_top-left",	
		],
		"top": [
			"dirt", 
			"grass-dirt_bottom",
			"grass-dirt_bottom-left",
			"grass-dirt_bottom-right"
		],
		"bottom": [
			"grass", 
			"grass-dirt_bottom", 
			"grass-dirt_corner_bottom-left",
			"grass-dirt_corner_bottom-right"
		]
	},	
	"grass-dirt_right": {
		"left": [
			"grass", 
			"grass-dirt_corner_bottom-left",
			"grass-dirt_corner_top-left"
		],
		"right": [
			"dirt", 
			"grass-dirt_left",
			"grass-dirt_bottom-left",
			"grass-dirt_top-left"
		],
		"top": [
			"grass-dirt_right", 
			"grass-dirt_top-right",
			"grass-dirt_corner_bottom-right",
		],
		"bottom": [
			"grass-dirt_right", 
			"grass-dirt_bottom-right",
			"grass-dirt_corner_top-right",
		]
	},
	"grass-dirt_bottom": {
		"left": [
			"grass-dirt_bottom", 
			"grass-dirt_bottom-left",
			"grass-dirt_corner_bottom-right",
		],
		"right": [
			"grass-dirt_bottom", 
			"grass-dirt_bottom-right",
			"grass-dirt_corner_bottom-left",
		],
		"top": [
			"grass", 
			"grass-dirt_top",
			"grass-dirt_corner_top-left",
			"grass-dirt_corner_top-right"
		],
		"bottom": [
			"dirt", 
			"grass-dirt_top", 
			"grass-dirt_top-left", 
			"grass-dirt_top-right"
		]
	},
	"grass-dirt_left": {
		"left": [
			"dirt", 
			"grass-dirt_right",
			"grass-dirt_bottom-right",
			"grass-dirt_top-right"
		],
		"right": [
			"grass",
			"grass-dirt_corner_bottom-right",
			"grass-dirt_corner_top-right"
		],
		"top": [
			"grass-dirt_left",
			"grass-dirt_top-left",
			"grass-dirt_corner_bottom-left",
		],
		"bottom": [
			"grass-dirt_left",
			"grass-dirt_bottom-left",
			"grass-dirt_corner_top-left",
		]
	},
	# --------- NAROZNIKI ---------
	"grass-dirt_top-right": {
		"left": [
			"grass-dirt_top", 
			"grass-dirt_corner_top-right",
			"grass-dirt_top-left"
		],
		"right": [
			"dirt", 
			"grass-dirt_left",
			"grass-dirt_top-left",
			"grass-dirt_bottom-left"
		],
		"top": [
			"dirt", 
			"grass-dirt_bottom",
			"grass-dirt_bottom-left",
			"grass-dirt_bottom-right",
			"grass-dirt_bottom-left"
		],
		"bottom": ["grass-dirt_right", "grass-dirt_corner_top-right", "grass-dirt_bottom-right"]
	},
	"grass-dirt_top-left": {
		"left": [
			"dirt", 
			"grass-dirt_right",
			"grass-dirt_top-right",
			"grass-dirt_bottom-right"
		],
		"right": [
			"grass-dirt_top", 
			"grass-dirt_corner_top-left",
			"grass-dirt_top-right",
		],
		"top": [
			"dirt", 
			"grass-dirt_bottom",
			"grass-dirt_bottom-left",
			"grass-dirt_bottom-right"
		],
		"bottom": ["grass-dirt_left", "grass-dirt_corner_top-left", "grass-dirt_bottom-left"]
	},
	"grass-dirt_bottom-right": {
		"left": [
			"grass-dirt_bottom", 
			"grass-dirt_bottom-left",
			"grass-dirt_corner_bottom-right"
		],
		"right": [
			"dirt", 
			"grass-dirt_left",
			"grass-dirt_bottom-left",
			"grass-dirt_top-left"			
		],
		"top": ["grass-dirt_right", "grass-dirt_corner_bottom-right", "grass-dirt_top-right"],
		"bottom": [
			"dirt", 
			"grass-dirt_top",
			"grass-dirt_top-left",
			"grass-dirt_top-right"
		]
	},
	"grass-dirt_bottom-left": {
		"left": [
			"dirt", 
			"grass-dirt_right",
			"grass-dirt_bottom-right",
			"grass-dirt_top-right"
		],
		"right": [
			"grass-dirt_bottom", 
			"grass-dirt_corner_bottom-left",
			"grass-dirt_bottom-right",
		],
		"top": ["grass-dirt_left", "grass-dirt_corner_bottom-left", "grass-dirt_top-left"],
		"bottom": [
			"dirt", 
			"grass-dirt_top",
			"grass-dirt_top-left",
			"grass-dirt_top-right",
		]
	},
	# L-ki narozniki
	"grass-dirt_corner_top-left": {
		"left": ["grass-dirt_top", "grass-dirt_top-left", "grass-dirt_corner_top-right"],
		"right": [
			"grass", 
			"grass-dirt_right",
			"grass-dirt_corner_top-right",
			"grass-dirt_corner_bottom-right"
		],
		"top": [
			"grass-dirt_left", 
			"grass-dirt_top-left", 
			"grass-dirt_corner_bottom-left"
		],
		"bottom": [
			"grass", 
			"grass-dirt_bottom",
			"grass-dirt_corner_bottom-left"
		]
	},
	"grass-dirt_corner_top-right": {
		"left": [
			"grass", 
			"grass-dirt_left",
			"grass-dirt_corner_top-left",
			"grass-dirt_corner_bottom-left"
		],
		"right": ["grass-dirt_top", "grass-dirt_top-right", "grass-dirt_corner_top-left"],
		"top": [
			"grass-dirt_right", 
			"grass-dirt_top-right", 
			"grass-dirt_corner_bottom-right"
		],
		"bottom": [
			"grass", 
			"grass-dirt_bottom",
			"grass-dirt_corner_bottom-right"
		]
	},
	"grass-dirt_corner_bottom-left": {
		"left": [
			"grass-dirt_bottom", 
			"grass-dirt_bottom-left", 
			"grass-dirt_corner_bottom-right"
		],
		"right": [
			"grass",  
			"grass-dirt_right",
			"grass-dirt_corner_top-right"
		],
		"top": [
			"grass", 
			"grass-dirt_top"
		],
		"bottom": [
			"grass-dirt_left", 
			"grass-dirt_bottom-left", 
			"grass-dirt_corner_top-left"
		]
	},
	"grass-dirt_corner_bottom-right": {
		"left": [
			"grass", 
			"grass-dirt_left",
			"grass-dirt_corner_bottom-left",
			"grass-dirt_corner_top-left"
		],
		"right": [
			"grass-dirt_bottom", 
			"grass-dirt_bottom-right", 
			"grass-dirt_corner_bottom-left"
		],
		"top": ["grass", "grass-dirt_top"],
		"bottom": [
			"grass-dirt_right", 
			"grass-dirt_bottom-right", 
			"grass-dirt_corner_top-right"
		]
	},
}

static var adjacencyRulesAsIndexes = {}

static func initialize():
	adjacencyRulesAsIndexes.clear()
	
	for tileName in adjacencyRules.keys():
		var tileIndex = Tiles.getIndex(tileName)
		
		if tileIndex == -1:
			print_debug("Oopsie Tile '%s' is not defined" % tileName)
			continue
		
		adjacencyRulesAsIndexes[tileIndex] = {}
		
		for direction in adjacencyRules[tileName].keys():
			adjacencyRulesAsIndexes[tileIndex][direction] = []
			
			for neighbor_name in adjacencyRules[tileName][direction]:
				var neighborIndex = Tiles.getIndex(neighbor_name)
				
				if neighborIndex == -1:
					print_debug("Oopsie Neighbor tile '%s' not found" % neighbor_name)
					continue
				
				adjacencyRulesAsIndexes[tileIndex][direction].append(neighborIndex)

	_printRules()

static func _printRules():
	print("\n------- Translated tiles rules -------")
	for tileIndex in adjacencyRulesAsIndexes.keys():
		print(Tiles.getName(tileIndex) + ": " + str(adjacencyRulesAsIndexes[tileIndex]))

static func isPossibleNeighbor(tileIndex: int, neighborIndex: int, direction: String) -> bool:
	if adjacencyRulesAsIndexes.has(tileIndex) and adjacencyRulesAsIndexes[tileIndex].has(direction):
		return neighborIndex in adjacencyRulesAsIndexes[tileIndex][direction]
	return false
