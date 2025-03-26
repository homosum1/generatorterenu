extends Node2D

var visible_grid := false
var tile_size := 16 
var grid_width := 0
var grid_height := 0
var CHUNK_WIDTH := 0
var CHUNK_HEIGHT := 0
var CHUNKS_COUNT_WIDTH := 0
var CHUNKS_COUNT_HEIGHT := 0


func _ready():
	var chunk_rendering = get_parent()

	if chunk_rendering:
		CHUNK_WIDTH = chunk_rendering.CHUNK_WIDTH
		CHUNK_HEIGHT = chunk_rendering.CHUNK_HEIGHT
	
		CHUNKS_COUNT_WIDTH = chunk_rendering.CHUNKS_COUNT_WIDTH
		CHUNKS_COUNT_HEIGHT = chunk_rendering.CHUNKS_COUNT_HEIGHT
		
		grid_width = CHUNK_WIDTH * CHUNKS_COUNT_WIDTH + (CHUNKS_COUNT_WIDTH - 1)
		grid_height = CHUNK_HEIGHT * CHUNKS_COUNT_HEIGHT + (CHUNKS_COUNT_HEIGHT - 1)
	else:
		push_warning("⚠️ chunkRendering not found!")

	queue_redraw()

func _draw() -> void:
	if not visible_grid:
		return
	
	var color = Color(1, 1, 1, 0.4)
	var stitch_color = Color(1, 0, 0, 0.2)

	# vertical stitching
	for x in range(1, CHUNKS_COUNT_WIDTH):
		var x_pos = x * CHUNK_WIDTH + (x - 1)
		var px = x_pos * tile_size
		draw_rect(Rect2(px, 0, tile_size, grid_height * tile_size), stitch_color)

	# horizontal stitching
	for y in range(1, CHUNKS_COUNT_HEIGHT):
		var y_pos = y * CHUNK_HEIGHT + (y - 1)
		var py = y_pos * tile_size
		draw_rect(Rect2(0, py, grid_width * tile_size, tile_size), stitch_color)

	
	for x in range(grid_width + 1):
		var x_pos = x * tile_size
		draw_line(Vector2(x_pos, 0), Vector2(x_pos, grid_height * tile_size), color)
	for y in range(grid_height + 1):
		var y_pos = y * tile_size
		draw_line(Vector2(0, y_pos), Vector2(grid_width * tile_size, y_pos), color)

func toggle_grid():
	visible_grid = !visible_grid
	queue_redraw()
