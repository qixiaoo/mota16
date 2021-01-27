extends KinematicBody2D


enum { LEFT, RIGHT, }


onready var anim_sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer


var orientation := RIGHT

var run_speed := 50
var jump_speed := -100
var gravity := 100
var velocity := Vector2()


func get_input() -> void:
	velocity.x = 0
	
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed("ui_up")

	if is_on_floor() and jump:
		velocity.y = jump_speed
	if left:
		orientation = LEFT
		velocity.x -= run_speed
		anim_sprite.flip_h = false
	if right:
		orientation = RIGHT
		velocity.x += run_speed
		anim_sprite.flip_h = true


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.has_method("interact_with_pc"):
		area.interact_with_pc(self)


func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_method("interact_with_pc"):
		body.interact_with_pc(self)
