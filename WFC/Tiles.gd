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
	
# walls	
	{"name": "dirt-wall", "index": 100},
	{"name": "empty-wall", "index": 101},
	
	# wall sides
	{"name": "dirt-wall_right", "index": 102},
	{"name": "dirt-wall_bottom", "index": 103},
	{"name": "dirt-wall_left", "index": 104},
	{"name": "dirt-wall_top", "index": 105},
	 
	# wall corners
	{"name": "dirt-wall_corner_top-left", "index": 106},
	{"name": "dirt-wall_corner_top-right", "index": 107},
	{"name": "dirt-wall_corner_bottom-left", "index": 108},
	{"name": "dirt-wall_corner_bottom-right", "index": 109},
	
	# wall edges
	{"name": "dirt-wall_bottom-right", "index": 110},
	{"name": "dirt-wall_bottom-left", "index": 111},
	{"name": "dirt-wall_top-right", "index": 112},
	{"name": "dirt-wall_top-left", "index": 113},
		
	
	# wall step
	{"name": "top-dirt-wall_left", "index": 114},
	{"name": "top-dirt-wall_mid", "index": 115},
	{"name": "top-dirt-wall_right", "index": 116},
	{"name": "down-dirt-wall_left", "index": 117},
	{"name": "down-dirt-wall_mid", "index": 118},
	{"name": "down-dirt-wall_right", "index": 119},
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
