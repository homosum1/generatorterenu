extends Node

@onready var camera = get_node("/root/Node2D/Player/Camera2D")
@onready var grid_overlay := $"../../GridOverlay"
@onready var zoom_label: Label = $ZoomButtons/ZoomLabel
@onready var sliders_panel: Panel = $"Sliders"

@onready var hills = $"../../Hills"
@onready var nature = $"../../GrassLayer"
@onready var land = $"../../TileMapLayer"
@onready var underground = $"../../Underground"
@onready var evolution = $"../../Populations"

@onready var closeButton = $"HelpPanel/CloseButton"

var zoom_step := 0.1
var min_zoom := 0.2
var max_zoom := 3.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sliders_panel.visible = false
	camera.zoom = Vector2(1.0, 1.0) 
	
	$OpenHelpButton.pressed.connect(_on_show_help_pressed)
	$CloseAppButton.pressed.connect(_on_exit_pressed)

	closeButton.pressed.connect(_on_hide_help_pressed)

func _on_exit_pressed():
	get_tree().quit()

func _on_show_help_pressed():
	$HelpPanelMask.visible = true
	$HelpPanel.visible = true

func _on_hide_help_pressed():
	$HelpPanelMask.visible = false
	$HelpPanel.visible = false	

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


func _on_position_display_toggled(toggled_on: bool) -> void:
	grid_overlay.toggle_position()


func _on_menu_opened_toggled(toggled_on: bool) -> void:
	sliders_panel.visible = toggled_on
	

func _on_hills_checkbox_toggled(toggled_on: bool) -> void:
	hills.visible = toggled_on

func _on_nature_checkbox_2_toggled(toggled_on: bool) -> void:
	nature.visible = toggled_on

func _on_land_checkbox_3_toggled(toggled_on: bool) -> void:
	land.visible = toggled_on

func _on_underground_checkbox_4_toggled(toggled_on: bool) -> void:
	underground.visible = toggled_on

func _on_evolution_toggled(toggled_on: bool) -> void:
	evolution.visible = toggled_on
