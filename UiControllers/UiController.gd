extends Node

@onready var camera = get_node("/root/Node2D/Player/Camera2D")
@onready var grid_overlay := $"../../GridOverlay"
@onready var zoom_label: Label = $ZoomButtons/ZoomLabel  # Adjust path if needed


var zoom_step := 0.1
var min_zoom := 0.2
var max_zoom := 3.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	zoom_label.text = "Zoom: " + str(_round_to(camera.zoom.x, 2))

func _round_to(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor


func _on_zoom_in_pressed() -> void:
	var new_zoom = camera.zoom + Vector2(zoom_step, zoom_step)
	camera.zoom = Vector2(
		clampf(new_zoom.x, min_zoom, max_zoom),
		clampf(new_zoom.y, min_zoom, max_zoom)
	)

func _on_zoom_out_pressed() -> void:
	var new_zoom = camera.zoom - Vector2(zoom_step, zoom_step)
	camera.zoom = Vector2(
		clampf(new_zoom.x, min_zoom, max_zoom),
		clampf(new_zoom.y, min_zoom, max_zoom)
	)

func _on_display_grid_toggled(toggled_on: bool) -> void:
	grid_overlay.toggle_grid()


func _on_entropy_display_toggled(toggled_on: bool) -> void:
	grid_overlay.toggle_entropy() 
