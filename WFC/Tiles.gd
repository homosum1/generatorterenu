class_name Tiles
extends Object

const tiles = [
	{"name": "grass", "index": 0},
	{"name": "dirt", "index": 1},
# sides
	{"name": "grass-dirt_left", "index": 2},
	{"name": "grass-dirt_top", "index": 3},
	{"name": "grass-dirt_right", "index": 4},
	{"name": "grass-dirt_bottom", "index": 5},
# edges
	{"name": "grass-dirt_top-left", "index": 6},
	{"name": "grass-dirt_top-right", "index": 7},
	{"name": "grass-dirt_bottom-left", "index": 8},
	{"name": "grass-dirt_bottom-right", "index": 9},	
# corners
	{"name": "grass-dirt_corner_top-left", "index": 10},
	{"name": "grass-dirt_corner_top-right", "index": 11},
	{"name": "grass-dirt_corner_bottom-left", "index": 12},
	{"name": "grass-dirt_corner_bottom-right", "index": 13},
	
	
	# do 19 (potem zawiniecie mapy)

# cobblestone  
	{"name": "stone", "index": 40},
	# stone - sides
	{"name": "stone-dirt_left", "index": 42},
	{"name": "stone-dirt_top", "index": 43},
	{"name": "stone-dirt_right", "index": 44},
	{"name": "stone-dirt_bottom", "index": 45},

	# stone - edges
	{"name": "stone-dirt_top-left", "index": 46},
	{"name": "stone-dirt_top-right", "index": 47},
	{"name": "stone-dirt_bottom-left", "index": 48},
	{"name": "stone-dirt_bottom-right", "index": 49},	

	# stone - corners
	{"name": "stone-dirt_corner_top-left", "index": 50},
	{"name": "stone-dirt_corner_top-right", "index": 51},
	{"name": "stone-dirt_corner_bottom-left", "index": 52},
	{"name": "stone-dirt_corner_bottom-right", "index": 53},

# lake  
	{"name": "water", "index": 60},
	# water - sides
	{"name": "water-dirt_left", "index": 62},
	{"name": "water-dirt_top", "index": 63},
	{"name": "water-dirt_right", "index": 64},
	{"name": "water-dirt_bottom", "index": 65},

	# water - edges
	{"name": "water-dirt_bottom-left", "index": 66},
	{"name": "stone-dirt_bottom-right", "index": 67},
	{"name": "water-dirt_top-left", "index": 68},
	{"name": "water-dirt_top-right", "index": 69},	

	# water - corners
	{"name": "water-dirt_corner_top-left", "index": 70},
	{"name": "water-dirt_corner_top-right", "index": 71},
	{"name": "water-dirt_corner_bottom-left", "index": 71},
	{"name": "water-dirt_corner_bottom-right", "index": 73},


# walls	
	{"name": "dirt-wall", "index": 80},
	{"name": "empty-wall", "index": 81},
	
	# wall sides
	{"name": "dirt-wall_right", "index": 82},
	{"name": "dirt-wall_bottom", "index": 83},
	{"name": "dirt-wall_left", "index": 84},
	{"name": "dirt-wall_top", "index": 85},
	 
	# wall corners
	{"name": "dirt-wall_corner_top-left", "index": 86},
	{"name": "dirt-wall_corner_top-right", "index": 87},
	{"name": "dirt-wall_corner_bottom-left", "index": 88},
	{"name": "dirt-wall_corner_bottom-right", "index": 89},
	
	# wall edges
	{"name": "dirt-wall_bottom-right", "index": 90},
	{"name": "dirt-wall_bottom-left", "index": 91},
	{"name": "dirt-wall_top-right", "index": 92},
	{"name": "dirt-wall_top-left", "index": 93},
		
	
	# wall step
	{"name": "top-dirt-wall_left", "index": 94},
	{"name": "top-dirt-wall_mid", "index": 95},
	{"name": "top-dirt-wall_right", "index": 96},
	{"name": "down-dirt-wall_left", "index": 97},
	{"name": "down-dirt-wall_mid", "index": 98},
	{"name": "down-dirt-wall_right", "index": 99},
	
]



static var nameToIndex := {}
static var indexToName := {}

static var GRASS_TILE_ID := -1
static var DIRT_TILE_ID := -1
static var EDGE_TILE_IDS := []

static func initialize():
	nameToIndex.clear()
	indexToName.clear()
	
	for tile in tiles:
		nameToIndex[tile.name] = tile.index
		indexToName[tile.index] = tile.name
		
	GRASS_TILE_ID = getIndex("grass")
	DIRT_TILE_ID = getIndex("dirt")

	EDGE_TILE_IDS = [
		getIndex("grass-dirt_left"),
		getIndex("grass-dirt_right"),
		getIndex("grass-dirt_top"),
		getIndex("grass-dirt_bottom"),
		
		getIndex("grass-dirt_top-left"),
		getIndex("grass-dirt_top-right"),
		getIndex("grass-dirt_bottom-left"),
		getIndex("grass-dirt_bottom-right"),
		
		getIndex("grass-dirt_corner_top-left"),
		getIndex("grass-dirt_corner_top-right"),
		getIndex("grass-dirt_corner_bottom-left"),
		getIndex("grass-dirt_corner_bottom-right"),
	]
		
	print("\n------- Tiles mapping after initialization -------")
	for tile_name in nameToIndex.keys():
		print(tile_name, " -> ", nameToIndex[tile_name])

static func getIndex(name: String) -> int:
	return nameToIndex.get(name, -1)  

static func getName(index: int) -> String:
	return indexToName.get(index, "unknown")
