extends CharacterBody2D

@export var speed := 150.0  # px/s


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 0



func _process(delta: float) -> void:
	var direction = Vector2.ZERO

	if Input.is_key_pressed(KEY_W):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S):
		direction.y += 1
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D):
		direction.x += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()

	position += direction * speed * delta

	#z_index = int(global_position.y / 16.0)
