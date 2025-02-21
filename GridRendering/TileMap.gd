extends TileMapLayer  
@export var wfc_path: NodePath # Reference to WFC generator
var wfc

func _ready() -> void:
	wfc = get_node(wfc_path)

	if not wfc:
		print("Missing wfc generator")
		return

	wfc.calulateWFC() # run wfc before render
	
	renderWFCGrid(wfc.gridMatrix)

func renderWFCGrid(gridMatrix):
	clear() 

	for x in range(gridMatrix.size()):
		for y in range(gridMatrix[x].size()):
			var tile = gridMatrix[x][y]
			set_cell(Vector2i(x, y), 0, Vector2i(tile.collapsedState, 0))
