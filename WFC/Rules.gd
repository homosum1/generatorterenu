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
	"grass-dirt_top": {
		"left": [
			"grass-dirt_top", 
			"grass-dirt_top-left",
			"grass-dirt_corner_top-left"	
		],
		"right": [
			"grass-dirt_top", 
			"grass-dirt_top-right",
			"grass-dirt_corner_top-right",	
		],
		"top": ["dirt"],
		"bottom": ["grass"]
	},	
	"grass-dirt_right": {
		"left": ["grass"],
		"right": ["dirt"],
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
			"grass-dirt_corner_bottom-right",
		],
		"top": ["grass"],
		"bottom": ["dirt"]
	},
	"grass-dirt_left": {
		"left": ["dirt"],
		"right": ["grass"],
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
	"grass-dirt_top-right": {
		"left": ["grass-dirt_top", "grass-dirt_corner_top-right"],
		"right": ["dirt"],
		"top": ["dirt"],
		"bottom": ["grass-dirt_right", "grass-dirt_corner_top-right"]
	},
	"grass-dirt_top-left": {
		"left": ["dirt"],
		"right": ["grass-dirt_top", "grass-dirt_corner_top-right"],
		"top": ["dirt"],
		"bottom": ["grass-dirt_left", "grass-dirt_corner_top-right"]
	},
	"grass-dirt_bottom-right": {
		"left": ["grass-dirt_bottom", "grass-dirt_corner_bottom-right"],
		"right": ["dirt"],
		"top": ["grass-dirt_right", "grass-dirt_corner_bottom-right"],
		"bottom": ["dirt"]
	},
	"grass-dirt_bottom-left": {
		"left": ["dirt"],
		"right": ["grass-dirt_bottom", "grass-dirt_corner_bottom-left"],
		"top": ["grass-dirt_left", "grass-dirt_corner_bottom-left"],
		"bottom": ["dirt"]
	},
	"grass-dirt_corner_top-left": {
		"left": ["grass-dirt_top", "grass-dirt_top-left", "grass-dirt_corner_top-right"],
		"right": ["grass"],
		"top": ["grass-dirt_left", "grass-dirt_top-left", "grass-dirt_corner_bottom-left"],
		"bottom": ["grass"]
	},
		"grass-dirt_corner_top-right": {
		"left": ["grass"],
		"right": ["grass-dirt_top", "grass-dirt_top-right", "grass-dirt_corner_top-left"],
		"top": ["grass-dirt_left", "grass-dirt_top-right", "grass-dirt_corner_bottom-right"],
		"bottom": ["grass"]
	},
	"grass-dirt_corner_bottom-left": {
		"left": ["grass-dirt_bottom", "grass-dirt_bottom-left", "grass-dirt_corner_bottom-left"],
		"right": ["grass"],
		"top": ["grass"],
		"bottom": ["grass-dirt_right", "grass-dirt_bottom-left", "grass-dirt_corner_top-left"]
	},
	"grass-dirt_corner_bottom-right": {
		"left": ["grass"],
		"right": ["grass-dirt_bottom", "grass-dirt_bottom-right", "grass-dirt_corner_bottom-left"],
		"top": ["grass"],
		"bottom": ["grass-dirt_right", "grass-dirt_bottom-left", "grass-dirt_corner_top-right"]
	},
}

static var adjacencyRulesAsIndexes = {}

static func _init():
	for tileName in adjacencyRules.keys():
		var tileIndex = Tiles.getIndex(tileName)
		
		if tileIndex != -1:
			adjacencyRulesAsIndexes[tileIndex] = {}
			
			for direction in adjacencyRules[tileName].keys():
				adjacencyRulesAsIndexes[tileIndex][direction] = []
				for neighbor_name in adjacencyRules[tileName][direction]:
					var neighborIndex = Tiles.getIndex(neighbor_name)
					if neighborIndex != -1:
						adjacencyRulesAsIndexes[tileIndex][direction].append(neighborIndex)

static func isPossibleNeighbor(tileIndex: int, direction: String) -> Array:
	return adjacencyRulesAsIndexes.get(tileIndex, {}).get(direction, [])
