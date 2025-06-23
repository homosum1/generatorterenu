class_name GeneticAlgorithm
extends Object




@export var edge_tiles: Array[int] = [] # indeksy kafelków brzegowych
@export var expected_edge_density: float = 0.25
@export var expected_logical_density: float = 0.45
@export var alpha: float = 0.7
@export var beta: float = 0.3
@export var number_of_recalculated_chunks = 0.3
@export var initial_population_size = 2

var chunk_fitness_map: Dictionary = {}

var CHUNK_WIDTH = null
var CHUNK_HEIGHT = null

var protected_ranges = [Vector2i(40,53), Vector2i(60, 73)]

var all_generations := {}  
# Dictionary<(epoch_number:int), Dictionary<chunk_pos:Vector2i, chunk_map:Array>>

func is_protected(index: int) -> bool:
	for range in protected_ranges:
		if index >= range.x and index <= range.y:
			return true
	return false
	
#func print_matrix(world_map: Array) -> void:
	#for y in range(world_map[0].size()):
		#var row_output := ""
		#for x in range(world_map.size()):
			#var val = world_map[x][y]
			#row_output += " " + str(val.collapsedState) + " "
		#print(row_output)


func _init(world_map: Array, chunk_width: int, chunk_height: int) -> void:	
	
	CHUNK_WIDTH = chunk_width
	CHUNK_HEIGHT = chunk_height
	
	for chunk_x in range(world_map.size()):
		for chunk_y in range(world_map[0].size()):
			var chunk = world_map[chunk_x][chunk_y]
			if chunk == null:
				continue
	
			#print_matrix(chunk)
			
			var fitness = evaluate_fitness(chunk)
			
			chunk_fitness_map[Vector2i(chunk_x, chunk_y)] = fitness

	var sorted_chunks = chunk_fitness_map.keys()
	sorted_chunks.sort_custom(func(a, b):
		return chunk_fitness_map[a] < chunk_fitness_map[b]
	)

	var num_chunks_to_select = ceil(sorted_chunks.size() * number_of_recalculated_chunks)
	var worst_chunks = sorted_chunks.slice(0, num_chunks_to_select)

	# executing genetic algorithm
	for chunk_pos in worst_chunks:
		var chunk = world_map[chunk_pos.x][chunk_pos.y]
		print("Running genetic algorithm for chunk at: ", chunk_pos, " with initial fitness: ", chunk_fitness_map[chunk_pos])
		initialize_population(world_map, chunk_pos, 0)


func trim_edges_2d_array(original: Array, margin: int) -> Array:
	var height = original.size()
	var width = original[0].size()
	
	var trimmed := []

	for y in range(margin, height - margin):
		var row := []
		for x in range(margin, width - margin):
			row.append(original[y][x])
		trimmed.append(row)
	
	return trimmed


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

		chunk._printEntropyMap()

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

	#print("Initialized population for chunk ", chunk_pos)
	
	# initializing all_generations if it doesn't exists yet.
	if not all_generations.has(epoch_number):
		all_generations[epoch_number] = {}

	if not all_generations[epoch_number].has(chunk_pos):
		all_generations[epoch_number][chunk_pos] = []

	all_generations[epoch_number][chunk_pos] += population



# V1

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
