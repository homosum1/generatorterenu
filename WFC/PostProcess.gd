class_name PostProcess
extends Object

static func clean_up_edges(map: Array) -> void:
	var width = map.size()
	var height = map[0].size()
	
	print("cleanup width: ", width, " cleanup height: ", height)

	for x in range(width):
		for y in range(height):
			var tile = map[x][y].collapsedState
			
			if tile in Tiles.EDGE_TILE_IDS:				
				var has_grass_neighbor = false

				for dx in range(-1, 2):
					for dy in range(-1, 2):
						if dx == 0 and dy == 0:
							continue


						var nx = x + dx
						var ny = y + dy

						if nx >= 0 and ny >= 0 and nx < width and ny < height:
							var neighbor = map[nx][ny].collapsedState
							if neighbor == Tiles.GRASS_TILE_ID:
								has_grass_neighbor = true
								break
				
				if not has_grass_neighbor:
					map[x][y].collapsedState = Tiles.DIRT_TILE_ID
					map[x][y].entropy = 8
