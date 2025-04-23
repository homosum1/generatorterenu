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
			"grass-dirt_left",
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
			"grass-dirt_right",
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
			"grass-dirt_corner_bottom-left",
			"grass-dirt_corner_bottom-right"
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
			"grass-dirt_corner_bottom-right",
			"grass-dirt_corner_bottom-left"
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
			"grass-dirt_corner_top-right",
			"grass-dirt_corner_bottom-right"
		],
		"top": [
			"grass", 
			"grass-dirt_top",
			"grass-dirt_corner_top-left",
			"grass-dirt_corner_top-right"
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
		"top": [
			"grass", 
			"grass-dirt_top",
			"grass-dirt_corner_top-right",
			"grass-dirt_corner_top-left"
		],
		"bottom": [
			"grass-dirt_right", 
			"grass-dirt_bottom-right", 
			"grass-dirt_corner_top-right"
		]
	},
	
# WALLS
	"dirt-wall": {
		"left": [
			"dirt-wall", 
			"dirt-wall_left",
			"dirt-wall_corner_top-left",
			"dirt-wall_corner_bottom-left"
		],
		"right": [
			"dirt-wall",
			"dirt-wall_right",
			"dirt-wall_corner_top-right",
			"dirt-wall_corner_bottom-right"
		],
		"top": [
			"dirt-wall",
			"dirt-wall_top",
			"dirt-wall_corner_top-left",
			"dirt-wall_corner_top-right"
		],
		"bottom": [
			"dirt-wall",
			"dirt-wall_bottom",
			"dirt-wall_corner_bottom-left",
			"dirt-wall_corner_bottom-right"
		]
	},
	
	"empty-wall": {
		"left": [
			"empty-wall",
			"dirt-wall_right",
			"dirt-wall_bottom-right",
			"dirt-wall_top-right"
		],
		"right": [
			"empty-wall",
			"dirt-wall_left",
			"dirt-wall_bottom-left",
			"dirt-wall_top-left"
		],
		"top": [
			"empty-wall",
			"dirt-wall_bottom", # temp, replace with wall later
			"dirt-wall_bottom-left", # temp, replace with wall later
			"dirt-wall_bottom-right" # temp, replace with wall later
		],
		"bottom": [
			"empty-wall",
			"dirt-wall_top",
			"dirt-wall_top-left",
			"dirt-wall_top-right"
		]
	},
	
# WALL SIDES
	"dirt-wall_top": {
		"left": [
			"dirt-wall_top",
			"dirt-wall_top-left",
			"dirt-wall_corner_top-right"
		],
		"right": [
			"dirt-wall_top",
			"dirt-wall_top-right",
			"dirt-wall_corner_top-left"
		],
		"top": [
			"empty-wall",
		],
		"bottom": [
			"dirt-wall",
		]
	},
	
	"dirt-wall_bottom": {
		"left": [
			"dirt-wall_bottom",
			"dirt-wall_bottom-left",
			"dirt-wall_corner_bottom-right"
		],
		"right": [
			"dirt-wall_bottom",
			"dirt-wall_bottom-right",
			"dirt-wall_corner_bottom-left"
		],
		"top": [
			"dirt-wall",
		],
		"bottom": [
			"empty-wall"
		]
	},
	
	"dirt-wall_left": {
		"left": [
			"empty-wall"
		],
		"right": [
			"dirt-wall",
		],
		"top": [
			"dirt-wall_left",
			"dirt-wall_top-left",
			"dirt-wall_corner_bottom-left"
		],
		"bottom": [
			"dirt-wall_left",
			"dirt-wall_bottom-left",
			"dirt-wall_corner_top-left"
		]
	},
	
	"dirt-wall_right": {
		"left": [
			"dirt-wall",
		],
		"right": [
			"empty-wall"
		],
		"top": [
			"dirt-wall_right",
			"dirt-wall_top-right",
			"dirt-wall_corner_bottom-right"
		],
		"bottom": [
			"dirt-wall_right",
			"dirt-wall_bottom-right",			
			"dirt-wall_corner_top-right"
		]
	},
	
# WALL EDGES
	"dirt-wall_top-left": {
		"left": [
			"empty-wall"
		],
		"right": [
			"dirt-wall_top",
			"dirt-wall_top-right",
			"dirt-wall_corner_top-left"
		],
		"top": [
			"empty-wall"
		],
		"bottom": [
			"dirt-wall_left",
			"dirt-wall_corner_top-left"
		]
	},
	
	"dirt-wall_top-right": {
		"left": [
			"dirt-wall_top",
			"dirt-wall_top-left",
			"dirt-wall_corner_top-right"
		],
		"right": [
			"empty-wall"
		],
		"top": [
			"empty-wall"
		],
		"bottom": [
			"dirt-wall_right",
			"dirt-wall_corner_top-right"
		]
	},
	
	"dirt-wall_bottom-left": {
		"left": [
			"empty-wall"
		],
		"right": [
			"dirt-wall_bottom",
			"dirt-wall_corner_bottom-left"
		],
		"top": [
			"dirt-wall_left",
			"dirt-wall_corner_bottom-left"
		],
		"bottom": [
			"empty-wall"
		]
	},
	
	"dirt-wall_bottom-right": {
		"left": [
			"dirt-wall_bottom",
			"dirt-wall_corner_bottom-right"
		],
		"right": [
			"empty-wall"
		],
		"top": [
			"dirt-wall_right",
			"dirt-wall_corner_bottom-right"
		],
		"bottom": [
			"empty-wall"
		]
	},

# WALL CORNERS
	"dirt-wall_corner_top-left": {
		"left": [
			"dirt-wall_top",
			"dirt-wall_top-left"
		],
		"right": [
			"dirt-wall"
		],
		"top": [
			"dirt-wall_left",
			"dirt-wall_top-left"
		],
		"bottom": [
			"dirt-wall"
		]
	},
	
	"dirt-wall_corner_top-right": {
		"left": [
			"dirt-wall"
		],
		"right": [
			"dirt-wall_top",
			"dirt-wall_top-right"
		],
		"top": [
			"dirt-wall_right",
			"dirt-wall_top-right",
		],
		"bottom": [
			"dirt-wall"
		]
	},
	
	"dirt-wall_corner_bottom-left": {
		"left": [
			"dirt-wall_bottom",
			"dirt-wall_bottom-left"
		],
		"right": [
			"dirt-wall"
		],
		"top": [
			"dirt-wall"
		],
		"bottom": [
			"dirt-wall_left",
			"dirt-wall_bottom-left"
		]
	},
	
	"dirt-wall_corner_bottom-right": {
		"left": [
			"dirt-wall"
		],
		"right": [
			"dirt-wall_bottom",
			"dirt-wall_bottom-right"
		],
		"top": [
			"dirt-wall"
		],
		"bottom": [
			"dirt-wall_right",
			"dirt-wall_bottom-right"
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


static func test_neighbor_rule_symmetry():
	var directions = {
		"top": "bottom",
		"bottom": "top",
		"left": "right",
		"right": "left"
	}

	for tile_name in adjacencyRules.keys():
		var tile_rules = adjacencyRules[tile_name]
		for dir in tile_rules.keys():
			var neighbor_list = tile_rules[dir]
			for neighbor in neighbor_list:
				# sprawdź czy sąsiedni tile ma odwzajemnioną regułę
				if not adjacencyRules.has(neighbor):
					print("⚠️ Missing neighbor tile definition:", neighbor)
					continue
				if not directions.has(dir):
					print("⚠️ Unknown direction:", dir)
					continue
				var opposite_dir = directions[dir]
				var neighbor_rules = adjacencyRules[neighbor]

				if not neighbor_rules.has(opposite_dir):
					print("❌", neighbor, "has no", opposite_dir, "rule for", tile_name)
				elif not tile_name in neighbor_rules[opposite_dir]:
					print("❌", neighbor, ".", opposite_dir, "does not include", tile_name)
