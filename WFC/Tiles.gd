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
