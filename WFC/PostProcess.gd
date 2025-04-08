class_name PostProcess
extends Object


static func _recalculate_collapse(recalculate_queue) -> void:
	
	for tile in recalculate_queue:
		tile.reset_possible_states()
		#tile.reset_possible_states_v2()
		
		
	# find tile with minimal entropy, collapse it and cremove from queue
	while recalculate_queue.size() > 0:
		var min_entropy_tile = recalculate_queue[0]
		
		for tile in recalculate_queue:
			if tile.entropy < min_entropy_tile.entropy:
				min_entropy_tile = tile
		
		if(min_entropy_tile.collapsedState == -1):
			min_entropy_tile.collapse()
		recalculate_queue.erase(min_entropy_tile)


static func clean_up_edges(map: Array) -> void:
	var width = map.size()
	var height = map[0].size()

	var recalculate_queue: Array = []

	print("cleanup width: ", width, " cleanup height: ", height)

	for x in range(width):
		for y in range(height):
			var tile = map[x][y]
			if tile == null:
				continue

			const BUFER = 0

			if tile.collapsedState in Tiles.EDGE_TILE_IDS:
				var has_grass_neighbor = false

				for dx in range(-1-BUFER, 2+BUFER):
					for dy in range(-1-BUFER, 2+BUFER):
						if dx == 0 and dy == 0:
							continue

						var nx = x + dx
						var ny = y + dy

						if nx >= 0 and ny >= 0 and nx < width and ny < height:
							var neighbor = map[nx][ny]
							if neighbor != null and neighbor.collapsedState == Tiles.GRASS_TILE_ID:
								has_grass_neighbor = true
								break

				if not has_grass_neighbor:
					tile.collapsedState = Tiles.DIRT_TILE_ID
		
					# change neighbours entropy
					for dx in range(-1-BUFER, 2+BUFER):
						for dy in range(-1-BUFER, 2+BUFER):
							if dx == 0 and dy == 0:
								continue

							var nx = x + dx
							var ny = y + dy

							if nx >= 0 and ny >= 0 and nx < width and ny < height:
								var neighbor_tile = map[nx][ny]
								if neighbor_tile != null and neighbor_tile.collapsedState in Tiles.EDGE_TILE_IDS: 
									# reset tile
									neighbor_tile.possibleStates.clear()
									var possibleTilesCount = Tiles.tiles.size()
									for i in range(possibleTilesCount):
										neighbor_tile.possibleStates.append(true)
										
									neighbor_tile.collapsedState = -1
									neighbor_tile.entropy = neighbor_tile.possibleStates.size()
		
									recalculate_queue.append(neighbor_tile)

	_recalculate_collapse(recalculate_queue)
