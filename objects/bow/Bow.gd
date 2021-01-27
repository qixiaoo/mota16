extends Node2D


const ARROW_SCENE = preload("res://objects/bow/Arrow.tscn")

const arrow_velocity: int = 40


onready var sprite: Sprite = $Node2D/Sprite


var mouse_button_pressed: bool = false


func _ready() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)


func _unhandled_input(event: InputEvent) -> void:
	look_at_mouse_cursor()
	if event is InputEventMouseButton:
		if event.is_pressed():
			sprite.frame = 23
			mouse_button_pressed = true
		else:
			if mouse_button_pressed:
				shoot()
			sprite.frame = 22
			mouse_button_pressed = false


func _exit_tree() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func look_at_mouse_cursor() -> void:
	var m = get_global_mouse_position()
	var angle = get_angle_to(m)
	rotation += angle


func shoot() -> void:
	var instance = ARROW_SCENE.instance()
	instance.rotation = rotation
	instance.position = position
	instance.linear_velocity = Vector2.RIGHT.rotated(rotation) * arrow_velocity
	get_tree().root.add_child(instance)
