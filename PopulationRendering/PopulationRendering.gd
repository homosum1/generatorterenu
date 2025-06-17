extends TileMapLayer



#
#func render_population():
	#clear()
		#
	#for x in range(finalMapWidth):
		#for y in range(finalMapHeigth):
			#var tile_id = underground_map_wfc.gridMatrix[x][y].collapsedState
			#if tile_id != -1:
				#var tile_x = tile_id % 20
				#var tile_y = tile_id / 20
				##print("RENDERING: " + str(tile_x) + ", " + str(tile_y))
				#set_cell(Vector2i(x, y), 0, Vector2i(tile_x, tile_y))



func get_max_chunk_height_in_epoch(epoch: Dictionary, chunk_height: int) -> int:
	var max_y := 0
	for chunk_pos in epoch.keys():
		if chunk_pos.y > max_y:
			max_y = chunk_pos.y
	return (max_y + 1) * (chunk_height + 1)  # dodaj szew tutaj

func render_generations_column(all_generations: Dictionary, chunk_width: int, chunk_height: int, chunk_count: int) -> void:
	clear()

	if all_generations.is_empty():
		print("No generations to render.")
		return

	var sorted_epochs = all_generations.keys()
	sorted_epochs.sort()

	var effective_chunk_width = chunk_width + 1
	var effective_chunk_height = chunk_height + 1

	for epoch_number in sorted_epochs:
		var epoch = all_generations[epoch_number]

		for chunk_pos in epoch.keys():			
			var individuals = epoch[chunk_pos]
			if individuals.size() == 0:
				continue

			for i in range(individuals.size()):
				var individual = individuals[i]
				var chunk_map = individual["map"]

				var offset_x = (chunk_pos.x + i * (chunk_count + 1) )  * effective_chunk_width
				var offset_y = (epoch_number * get_max_chunk_height_in_epoch(epoch, chunk_height)) + (chunk_pos.y * effective_chunk_height)

				for x in range(chunk_width):
					for y in range(chunk_height):
						var tile = chunk_map[x][y]
						var tile_id = tile.collapsedState
						if tile_id != -1:
							var tile_x = tile_id % 20
							var tile_y = tile_id / 20
							set_cell(Vector2i(offset_x + x, offset_y + y), 0, Vector2i(tile_x, tile_y))
