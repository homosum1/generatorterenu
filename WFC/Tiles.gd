class_name Tiles
extends Object

const tiles = [
	{"name": "desert_tile", "index": 0},
	{"name": "forest_tile", "index": 1},
	{"name": "water_tile", "index": 2},
	{"name": "mountain_tile", "index": 3}
]


static var nameToIndex := {}
static var indexToName := {}

static func _init():
	for tile in tiles:
		nameToIndex[tile.name] = tile.index
		indexToName[tile.index] = tile.name

static func getIndex(name: String) -> int:
	return nameToIndex.get(name, -1)  

static func getName(index: int) -> String:
	return indexToName.get(index, "unknown")
