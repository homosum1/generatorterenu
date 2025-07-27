extends Node

func _ready():
	$GenerateButton.pressed.connect(_on_generate_pressed)
	$TextureButton.pressed.connect(_on_exit_pressed)

func _on_generate_pressed():
	var pre_configuration = preload("res://main_scene.tscn").instantiate()
	get_tree().root.add_child(pre_configuration)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = pre_configuration

func _on_exit_pressed():
	get_tree().quit()
