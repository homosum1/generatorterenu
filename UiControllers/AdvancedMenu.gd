extends Panel

@onready var grass_slider := $MenuContainer/GrassSlider
@onready var earth_slider := $MenuContainer/EarthSlider

@onready var grass_val_label := $MenuContainer/HBoxContainer/GrassinesVal
@onready var earth_val_label := $MenuContainer/HBoxContainer2/EarthnessVal

var grassines := 25
var earthness := 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect values to global singleton:
	GlobalsSingleton.debug_settings = self
	
	# set values range:
	grass_slider.min_value = 0
	grass_slider.max_value = 50
	grass_slider.step = 1
	
	earth_slider.min_value = 0
	earth_slider.max_value = 50
	earth_slider.step = 1
	
	grass_slider.value = grassines
	earth_slider.value = earthness
	
	grass_val_label.text = str(grassines)
	earth_val_label.text = str(earthness)
	
	grass_slider.connect("value_changed", _on_grass_slider_changed)
	earth_slider.connect("value_changed", _on_earth_slider_changed)

func _on_grass_slider_changed(value: float) -> void:
	grassines = value
	grass_val_label.text = str(grassines)

func _on_earth_slider_changed(value: float) -> void:
	earthness = value
	earth_val_label.text = str(earthness)

func get_grassines() -> int:
	return grassines

func get_earthness() -> int:
	return earthness
