class_name PostProcess
extends Object


static func _recalculate_collapse(recalculate_queue) -> void:
	for tile in recalculate_queue:	# temp 
		tile.reset_possible_states()
	for tile in recalculate_queue:
		tile._notifyNeighborsForNotCollapsed()

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

 				# check if edge has grass neighbor 
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





static func _get_surrounding_tiles_with_diagonals(tile: Tile) -> Array:
	var tiles: Array = [tile]

	var top = tile.neighbors.get("top")
	var bottom = tile.neighbors.get("bottom")
	var left = tile.neighbors.get("left")
	var right = tile.neighbors.get("right")

	if top:
		tiles.append(top)
	if bottom:
		tiles.append(bottom)
	if left:
		tiles.append(left)
	if right:
		tiles.append(right)

	if top and left:
		var top_left = top.neighbors.get("left")
		if top_left:
			tiles.append(top_left)

	if top and right:
		var top_right = top.neighbors.get("right")
		if top_right:
			tiles.append(top_right)

	if bottom and left:
		var bottom_left = bottom.neighbors.get("left")
		if bottom_left:
			tiles.append(bottom_left)

	if bottom and right:
		var bottom_right = bottom.neighbors.get("right")
		if bottom_right:
			tiles.append(bottom_right)

	return tiles

#static func checkIfTileIsNeighbor(tile: Tile) -> bool:
	

static func _fix_uncollapsed_tiles(map: Array) -> void:
	var width = map.size()
	var height = map[0].size()

	var uncollapsed_tiles = []
	var recalculate_queue = []
	
	var protected_tile_indices = [
		Tiles.getIndex("stone"),
	] + range(60, 74) # 74 is excluded

	for x in range(width):
		for y in range(height):
			var tile = map[x][y]
			
			if tile.entropy == 0 or tile.collapsedState == Tile.EMPTY_STATE:
				print(" - tile: " + str(tile.position) + " added to queue")
				uncollapsed_tiles.append(tile)
	
	while uncollapsed_tiles.size() > 0:
		var uncollapsedTile = uncollapsed_tiles[0]
		const BUFER = 0
		
		var surrounding_tiles = _get_surrounding_tiles_with_diagonals(uncollapsedTile)
		
		for tile in surrounding_tiles:
			
			if tile.collapsedState in protected_tile_indices:
				continue

			# reset tile
			var possibleTilesCount = Tiles.tiles[Tiles.tiles.size() - 1]["index"] + 1
			tile.possibleStates = []

			for i in range(possibleTilesCount):
				tile.possibleStates.append(false)
			
			var ranges = [Vector2i(0, 13), Vector2i(40, 53)]
			for range_pair in ranges:
				for i in range(range_pair.x, range_pair.y + 1):
					if i < tile.possibleStates.size():
						tile.possibleStates[i] = true
					
			tile.collapsedState = -1
			tile.entropy = tile.possibleStates.count(true)
			
#				disable selected generations
			tile.possibleStates[Tiles.getIndex("stone")] = false

			recalculate_queue.append(tile)
			#print("tile: " + str(tile.position) + " cleared")
						
		uncollapsed_tiles.erase(uncollapsedTile)
							
	_recalculate_collapse(recalculate_queue)


static func fix_tiles(map: Array, loops: int):
	for i in range(0, loops):
		print("-> FIXING LOOP: " + str(i))
		_fix_uncollapsed_tiles(map)
