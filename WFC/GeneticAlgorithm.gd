class_name GeneticAlgorithm
extends Object




@export var edge_tiles: Array[int] = [] # indeksy kafelków brzegowych
@export var expected_edge_density: float = 0.25
@export var expected_logical_density: float = 0.45
@export var alpha: float = 0.7
@export var beta: float = 0.3
@export var number_of_recalculated_chunks = 0.3
@export var initial_population_size = 4
@export var number_of_epochs = 1
@export var mutation_chance: float = 1.0


var chunk_fitness_map: Dictionary = {}

var CHUNK_WIDTH = null
var CHUNK_HEIGHT = null

var protected_ranges = [Vector2i(40,53), Vector2i(60, 73)]

var all_generations := {} 
# Dictionary<(epoch_number:int), Dictionary<chunk_pos:Vector2i, chunk_map:Array>>
var best_results := {}


func is_protected(index: int) -> bool:
	for range in protected_ranges:
		if index >= range.x and index <= range.y:
			return true
	return false
	
func crossover_chunks_to_child(parent_a: Array, parent_b: Array, chunk_width: int, chunk_height: int) -> WFC:
	var child := WFC.new(chunk_width, chunk_height)

	var mid_y := int(chunk_height / 2)

	for y in range(chunk_height):
		for x in range(chunk_width):


			var tile = child.gridMatrix[x][y]

			if y == mid_y:
				var parent_state = parent_a[x][y].collapsedState
				if is_protected(parent_state):
					tile.collapseTo(parent_state, true)
			elif y < mid_y:
				tile.collapseTo(parent_a[x][y].collapsedState, true)
			else:
				tile.collapseTo(parent_b[x][y].collapsedState, true)

	
	child.calculateWFC()

	return child

func mutate_chunk(wfc: WFC) -> void:
	var width = wfc.gridMatrix.size()
	var height = wfc.gridMatrix[0].size()

	var x = randi() % width
	var y = randi() % height
	
	var recalculate_queue: Array = []
	var center_tile = wfc.gridMatrix[x][y]

	var possibleTilesCount = Tiles.tiles.size()
	
	# do not mutate if tile is restricted or has restricted neighbors:
	if is_protected(center_tile.collapsedState):
		return

	for dir in ["top", "bottom", "left", "right"]:
		if center_tile.neighbors.has(dir):
			var neighbor_tile = center_tile.neighbors[dir]
			if is_protected(neighbor_tile.collapsedState):
				return
	
	
	# reset core tile and neighbor tiles
	center_tile.possibleStates.clear()
	for i in range(possibleTilesCount):
		center_tile.possibleStates.append(true)
		
	center_tile.collapsedState = -1
	center_tile.entropy = center_tile.possibleStates.size()

	recalculate_queue.append(center_tile)

	var directions = ["top", "bottom", "left", "right"]
	for dir in directions:
		if wfc.gridMatrix[x][y].neighbors.has(dir):
			var neighbor_tile = wfc.gridMatrix[x][y].neighbors[dir]

			neighbor_tile.possibleStates.clear()
			for i in range(possibleTilesCount):
				neighbor_tile.possibleStates.append(true)
				
			neighbor_tile.collapsedState = -1
			neighbor_tile.entropy = neighbor_tile.possibleStates.size()

			recalculate_queue.append(neighbor_tile)
			
	# recalculate collapse
	PostProcess._recalculate_collapse(recalculate_queue)


func print_fitness_improvement_for_worst_chunks(worst_chunks: Array, world_map: Array) -> void:
	print("\n\nFitness improvement for worst chunks")

	for chunk_pos in worst_chunks:
		if not best_results.has(chunk_pos):
			continue

		var original_chunk = world_map[chunk_pos.x][chunk_pos.y]
		if original_chunk == null:
			continue

		var initial_fitness = evaluate_fitness(original_chunk)
		var final_fitness = evaluate_fitness(best_results[chunk_pos])
		var diff = final_fitness - initial_fitness

		print("Chunk ", chunk_pos, ": Initial = ", str(initial_fitness),
			", Final = ", str(final_fitness), ", Δ = ", str(diff))


func replace_chunks_in_world_map(world_map: Array) -> void:
	for chunk_pos in best_results.keys():
		var winner_chunk = best_results[chunk_pos]
		if winner_chunk == null:
			continue

		for x in range(CHUNK_WIDTH):
			for y in range(CHUNK_HEIGHT):
				world_map[chunk_pos.x][chunk_pos.y][x][y] = winner_chunk[x][y]


func _init(world_map: Array, chunk_width: int, chunk_height: int) -> void:
	
	CHUNK_WIDTH = chunk_width
	CHUNK_HEIGHT = chunk_height
	
	for chunk_x in range(world_map.size()):
		for chunk_y in range(world_map[0].size()):
			var chunk = world_map[chunk_x][chunk_y]
			if chunk == null:
				continue
			
			var fitness = evaluate_fitness(chunk)
			
			chunk_fitness_map[Vector2i(chunk_x, chunk_y)] = fitness

	var sorted_chunks = chunk_fitness_map.keys()
	sorted_chunks.sort_custom(func(a, b):
		return chunk_fitness_map[a] < chunk_fitness_map[b]
	)

	var num_chunks_to_select = ceil(sorted_chunks.size() * number_of_recalculated_chunks)
	var worst_chunks = sorted_chunks.slice(0, num_chunks_to_select)

	# initializing first population
	for chunk_pos in worst_chunks:
		var chunk = world_map[chunk_pos.x][chunk_pos.y]
		print("Running genetic algorithm for chunk at: ", chunk_pos, " with initial fitness: ", chunk_fitness_map[chunk_pos])
		initialize_population(world_map, chunk_pos, 0)

	# executing genetic algorithm
	for epoch in range(1, number_of_epochs + 1):
		print("Epoch ", epoch)
		all_generations[epoch] = {}

		for chunk_pos in chunk_fitness_map.keys():
			if not all_generations[epoch - 1].has(chunk_pos):
				continue

			var prev_population = all_generations[epoch - 1][chunk_pos]
			var new_population := []

			# create next population	
			for i in range(initial_population_size):
				var parent_a = tournament_selection(prev_population, 2)
				var parent_b = tournament_selection(prev_population, 2)

				while parent_a["map"] == parent_b["map"]:
					parent_b = tournament_selection(prev_population, 2)

				var child = crossover_chunks_to_child(parent_a["map"], parent_b["map"], CHUNK_WIDTH, CHUNK_HEIGHT)
				
				# mutation
				if randf() < mutation_chance:
					mutate_chunk(child)

				
				new_population.append({
					"map": child.gridMatrix,
					"fitness": evaluate_fitness(child.gridMatrix)
				})

			all_generations[epoch][chunk_pos] = new_population
	
	# selecting final results 
	var final_epoch = all_generations[number_of_epochs]

	for chunk_pos in final_epoch.keys():
		var population = final_epoch[chunk_pos]
		if population.is_empty():
			continue

		population.sort_custom(func(a, b):
			return a["fitness"] > b["fitness"]
		)

		best_results[chunk_pos] = population[0]["map"]
	
	# print improvment 
	print_fitness_improvement_for_worst_chunks(worst_chunks ,world_map)

	# copy winners to final map
	replace_chunks_in_world_map(	world_map)

func tournament_selection(population: Array, tournament_size: int) -> Dictionary:
	var candidates := []

	while candidates.size() < tournament_size:
		var candidate = population[randi() % population.size()]
		if candidate not in candidates:
			candidates.append(candidate)

	candidates.sort_custom(func(a, b):
		return a["fitness"] > b["fitness"]
	)

	return candidates[0]

func evaluate_fitness(map: Array) -> float:
	var height = map.size()
	var width = map[0].size()
	var total: int = height * width
	
	var edge_tile_count := 0
	var logical_diff_count := 0
	
	for i in range(height):
		for j in range(width):
			var tile_index = map[i][j].collapsedState
			var tile_name = Tiles.getName(tile_index)

			if tile_name not in Tiles.not_edge_tiles:
				edge_tile_count += 1
			
			if i < height - 1 and (map[i][j].collapsedState != map[i+1][j].collapsedState):
				logical_diff_count += 1
			
			if j < width - 1 and (map[i][j].collapsedState != map[i][j+1].collapsedState):
				logical_diff_count += 1
	
	var rho_val = float(logical_diff_count) / total
	var lambda_val = float(edge_tile_count) / total

	var rho_penalty := 0.0
	if rho_val > expected_logical_density:
		rho_penalty = rho_val - expected_logical_density

	var lambda_penalty := 0.0
	if lambda_val > expected_edge_density:
		lambda_penalty = lambda_val - expected_edge_density

	return 1.0 - alpha * rho_penalty - beta * lambda_penalty



func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func initialize_population(world_map: Array, chunk_pos: Vector2i, epoch_number: int = 0) -> void:
	var population := []

	for i in range(initial_population_size):
		var chunk = WFC.new(CHUNK_WIDTH, CHUNK_HEIGHT)

		_copy_constant_neighbors(chunk, world_map, chunk_pos.x, chunk_pos.y)
		_inject_neighbors_rules(chunk, world_map, chunk_pos.x, chunk_pos.y)

		#chunk._printEntropyMap()

		chunk.enforce_proximity_rule("stone", 2, 40, 53)

		var result = chunk.calculateWFC()

		#PostProcess.clean_up_edges(result)
		#PostProcess.fix_tiles(result, 3)
		#PostProcess.clean_up_edges(result)
		
		#var trimmed_result = trim_edges_2d_array(result, 1)

		PostProcess.clean_up_edges(result, true)
		
		#PostProcess.fix_tiles(trimmed_result, 3)
		#PostProcess.clean_up_edges(trimmed_result)

		var fitness = evaluate_fitness(result)

		population.append({
			"map": result,
			"fitness": fitness
		})


	if not all_generations.has(epoch_number):
		all_generations[epoch_number] = {}

	if not all_generations[epoch_number].has(chunk_pos):
		all_generations[epoch_number][chunk_pos] = []

	all_generations[epoch_number][chunk_pos] += population




func _copy_constant_neighbors(chunk: WFC, world_map: Array, x: int, y: int) -> void:

	var source_chunk = world_map[x][y]
	if source_chunk == null:
		return

	for i in range(CHUNK_WIDTH):
		for j in range(CHUNK_HEIGHT):
			var tile = source_chunk[i][j]
			if tile == null:
				continue

			var state = tile.collapsedState
			if is_protected(state):
				var new_tile = chunk.gridMatrix[i][j]
				new_tile.collapseTo(state, true)


func _inject_neighbors_rules(chunk: WFC, world_map: Array, x: int, y: int) -> void:
		

	for i in range(CHUNK_HEIGHT):
		
		if world_map[x][y][CHUNK_WIDTH - 1][i].neighbors.has("right"):
			var world_right_tile = world_map[x][y][CHUNK_WIDTH - 1][i].neighbors["right"]
			var new_right_tile =  chunk.gridMatrix[CHUNK_WIDTH - 1][i]

			new_right_tile.neighbors["right"] = world_right_tile
			world_right_tile.neighbors["left"] = new_right_tile
			world_right_tile._notifyNeighbors()

		if world_map[x][y][0][i].neighbors.has("left"):
			var world_left_tile =  world_map[x][y][0][i].neighbors["left"] 
			var new_left_tile = chunk.gridMatrix[0][i]
			
			new_left_tile.neighbors["left"] = world_left_tile
			world_left_tile.neighbors["right"] = new_left_tile

			
			world_left_tile._notifyNeighbors()
		

	for i in range(CHUNK_WIDTH):
			
		if world_map[x][y][i][0].neighbors.has("top"):
			var world_top_tile = world_map[x][y][i][0].neighbors["top"]
			var new_top_tile = chunk.gridMatrix[i][0]
			
			new_top_tile.neighbors["top"] = world_top_tile
			world_top_tile.neighbors["bottom"] = new_top_tile
			world_top_tile._notifyNeighbors()

		if world_map[x][y][i][CHUNK_HEIGHT - 1].neighbors.has("bottom"):
			var world_bottom_tile = world_map[x][y][i][CHUNK_HEIGHT - 1].neighbors["bottom"]
			var new_bottom_tile = chunk.gridMatrix[i][CHUNK_HEIGHT - 1]

			new_bottom_tile.neighbors["bottom"] = world_bottom_tile
			world_bottom_tile.neighbors["top"] = new_bottom_tile
			world_bottom_tile._notifyNeighbors()
