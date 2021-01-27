extends StaticBody2D


class_name Door


enum DoorType { YELLOW, BLUE, RED, }


export(DoorType) var type = DoorType.YELLOW setget set_type, get_type


onready var sprite: Sprite = $Sprite


var key_id: String


func _ready() -> void:
	set_type(type)


func set_type(value: int) -> void:
	type = value
	
	if !sprite:
		return
	
	match type:
		DoorType.YELLOW:
			key_id = "黄钥匙"
			sprite.frame = 24
		DoorType.BLUE:
			key_id = "蓝钥匙"
			sprite.frame = 25
		DoorType.RED:
			key_id = "红钥匙"
			sprite.frame = 26


func get_type() -> int:
	return type


# warning-ignore:unused_argument
func interact_with_pc(pc: Node) -> bool:
	try_open()
	return true


func try_open() -> void:
	var required_key = key_id
	var amount = Data.get_inventory_amount_by_key(required_key)
	if amount >= 1:
		Data.set_inventory_amount_by_key(required_key, amount - 1)
		opened()


func opened() -> void:
	var parent = get_parent()
	if parent is TileMap:
		var coordinate = parent.world_to_map(position)
		Signal.emit_signal("s_consume_block", coordinate, "")
	else:
		print("Door should be instantiated by MiscMap.")
	
	queue_free()
