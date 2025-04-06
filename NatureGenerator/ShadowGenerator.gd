extends TileMapLayer

const SHADOW_TILES_ID = [Vector2i(2, 8), Vector2i(6, 8)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0.5 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func renderTreeShadows(natureMap: Array[Array], allowedIDs: Array):
	clear()
	
	var finalMapWidth = natureMap.size()
	var finalMapHeight = natureMap[0].size() if finalMapWidth > 0 else 0
	
	for x in range(finalMapWidth):
		for y in range(finalMapHeight):
			var tileID = natureMap[x][y]
			
			var index = allowedIDs.find(tileID)
			if index != -1:
				var shadow_tile = SHADOW_TILES_ID[index]
				set_cell(Vector2i(x, y), 0, shadow_tile)
