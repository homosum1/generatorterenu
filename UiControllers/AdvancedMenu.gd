extends Panel

# TILES SETTINGS REF:
@onready var grass_slider := $MenuContainer/GrassSlider
@onready var earth_slider := $MenuContainer/EarthSlider

@onready var grass_val_label := $MenuContainer/HBoxContainer/GrassinesVal
@onready var earth_val_label := $MenuContainer/HBoxContainer2/EarthnessVal

@onready var hills_frequency_slider := $SecondMenuContainer2/HillsFrequencySlider
@onready var hill_frequency_label := $SecondMenuContainer2/HBoxContainer/HillsFrequencyVal

@onready var hills_threshold_slider := $SecondMenuContainer2/HillsThresholdSlider
@onready var hills_threshold_label := $SecondMenuContainer2/HBoxContainer2/HillsThresholdVal


# STRUCTURE GEN REFS:
@onready var grass_density_slider := $SecondMenuContainer/GrassDensitySlider
@onready var tree_density_slider := $SecondMenuContainer/TreesDensitySlider
@onready var grass_frequency_slider := $SecondMenuContainer/GrassFreqSlider
@onready var tree_frequency_slider := $SecondMenuContainer/TreesFreqSlider

@onready var grass_density_label := $SecondMenuContainer/HBoxContainer/GrassDensityVal
@onready var tree_density_label := $SecondMenuContainer/HBoxContainer3/TreesDensityVal
@onready var grass_frequency_label := $SecondMenuContainer/HBoxContainer2/GrassFrequencyVal
@onready var tree_frequency_label := $SecondMenuContainer/HBoxContainer4/TreesFrequencyVal




var grassines := 25
var earthness := 3

var grass_density := 0.4
var tree_density := 0.1

var grass_frequency := 0.1
var tree_frequency := 0.03

var hills_frequency := 0.007
var hills_threshold := 0.7
var hillsGeneration := true


var underground_threshold := 0.4
var undergroundGeneration := true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect values to global singleton:
	GlobalsSingleton.debug_settings = self
	
	# set tiles values range:
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

	# set generated structures range:
	grass_density_slider.min_value = 0.0
	grass_density_slider.max_value = 1.0
	grass_density_slider.step = 0.01

	tree_density_slider.min_value = 0.0
	tree_density_slider.max_value = 0.5
	tree_density_slider.step = 0.01

	grass_frequency_slider.min_value = 0.01
	grass_frequency_slider.max_value = 0.5
	grass_frequency_slider.step = 0.01

	tree_frequency_slider.min_value = 0.01
	tree_frequency_slider.max_value = 0.2
	tree_frequency_slider.step = 0.01
	
	hills_frequency_slider.min_value = 0.001
	hills_frequency_slider.max_value = 0.050
	hills_frequency_slider.step = 0.001

	hills_threshold_slider.min_value = 0.1
	hills_threshold_slider.max_value = 1.0
	hills_threshold_slider.step = 0.05
	
	grass_density_slider.value = grass_density
	tree_density_slider.value = tree_density
	grass_frequency_slider.value = grass_frequency
	tree_frequency_slider.value = tree_frequency
	
	hills_frequency_slider.value = hills_frequency
	hills_threshold_slider.value = hills_threshold
		

	grass_density_label.text = "%.2f" % grass_density
	tree_density_label.text = "%.2f" % tree_density
	grass_frequency_label.text = "%.2f" % grass_frequency
	tree_frequency_label.text = "%.2f" % tree_frequency

	hill_frequency_label.text = "%.3f" % hills_frequency
	hills_threshold_label.text = "%.2f" % hills_threshold

	# Connect signals
	grass_density_slider.connect("value_changed", _on_grass_density_changed)
	tree_density_slider.connect("value_changed", _on_tree_density_changed)
	grass_frequency_slider.connect("value_changed", _on_grass_frequency_changed)
	tree_frequency_slider.connect("value_changed", _on_tree_frequency_changed)
	
	hills_frequency_slider.connect("value_changed", _on_hills_frequency_changed)
	hills_threshold_slider.connect("value_changed", _on_hills_threshold_changed)

	

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



func _on_grass_density_changed(value: float) -> void:
	grass_density = value
	grass_density_label.text = "%.2f" % value

func _on_tree_density_changed(value: float) -> void:
	tree_density = value
	tree_density_label.text = "%.2f" % value

func _on_grass_frequency_changed(value: float) -> void:
	grass_frequency = value
	grass_frequency_label.text = "%.2f" % value

func _on_tree_frequency_changed(value: float) -> void:
	tree_frequency = value
	tree_frequency_label.text = "%.2f" % value

func _on_hills_frequency_changed(value: float) -> void:
	hills_frequency = value
	hill_frequency_label.text = "%.3f" % value

func _on_hills_threshold_changed(value: float) -> void:	
	hills_threshold = value
	hills_threshold_label.text = "%.2f" % value


func get_grass_density() -> float:
	return grass_density

func get_tree_density() -> float:
	return tree_density

func get_grass_frequency() -> float:
	return grass_frequency

func get_tree_frequency() -> float:
	return tree_frequency
	
func get_hills_frequency() -> float:
	return hills_frequency

func get_hills_height_threshold() -> float:
	return hills_threshold

func get_are_hills_rendered() -> float:
	return hillsGeneration

func get_underground_height_threshold() -> float:
	return underground_threshold

func get_is_underground_rendered() -> float:
	return undergroundGeneration

func _on_position_display_toggled(toggled_on: bool) -> void:
	hillsGeneration = !hillsGeneration
