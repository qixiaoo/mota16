extends Area2D


class_name Portal


enum PortalType { UP, DOWN, }


export(PortalType) var type = PortalType.UP setget set_type, get_type


onready var sprite: Sprite = $Sprite


func _ready() -> void:
	set_type(type)


func set_type(value: int) -> void:
	type = value
	
	if !sprite:
		return
	
	match type:
		PortalType.UP:
			sprite.frame = 3
		PortalType.DOWN:
			sprite.frame = 4


func get_type() -> int:
	return type


# warning-ignore:unused_argument
func interact_with_pc(pc: Node) -> bool:
	change_level()
	return false


func change_level() -> void:
	var event = "s_next_level" if type == PortalType.UP else "s_prev_level"
	Signal.emit_signal(event)
