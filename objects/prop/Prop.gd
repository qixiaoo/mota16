extends StaticBody2D


class_name Prop


export(String) var prop_id


onready var sprite: Sprite = $Sprite


var prop_config: Dictionary


func _ready() -> void:
	prop_config = Data.get_prop_config_by_id(prop_id)
	sprite.frame = prop_config.get("frame")


# warning-ignore:unused_argument
func interact_with_pc(pc: Node) -> bool:
	consumed()
	return false


func consumed() -> void:
	var parent = get_parent()
	if parent is TileMap:
		var coordinate = parent.world_to_map(position)
		Signal.emit_signal("s_consume_prop", prop_id)
		Signal.emit_signal("s_consume_block", coordinate, prop_id)
	else:
		print("Prop should be instantiated by PropMap.")
	
	queue_free()
