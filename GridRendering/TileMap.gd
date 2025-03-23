extends TileMapLayer  
@export var wfc_path: NodePath # Reference to WFC generator
var wfc

func _ready() -> void:
	pass
	#wfc = get_node(wfc_path)
#
	#if not wfc:
		#print("Missing wfc generator")
		#return
#
	#wfc.calculateWFC() # run wfc before render
	#
	#renderWFCGrid(wfc.gridMatrix)

func clearMap():
	clear() 

func renderWFCGrid(gridMatrix: Array[Array], offset: Vector2i):

	for x in range(gridMatrix.size()):
		for y in range(gridMatrix[x].size()):
			var tile = gridMatrix[x][y]
			#set_cell(Vector2i(x, y), 0, Vector2i(tile.collapsedState, 0))
			set_cell(Vector2i(x + offset.x, y + offset.y), 0, Vector2i(tile.collapsedState, 0))
