extends Node


const BOW_SCENE = preload("res://objects/bow/Bow.tscn")


var bow = BOW_SCENE.instance()


func _ready() -> void:
	init_event()


func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		Data.save()
		get_tree().quit()


func init_event() -> void:
	Signal.on("s_save_game", self, "save_data")
	Signal.on("s_reload_data", self, "reload_data")
	Signal.on("s_back_to_main_menu", self, "back_to_main_menu")
	Signal.on("s_to_level", self, "to_level")
	Signal.on("s_next_level", self, "to_next_level")
	Signal.on("s_prev_level", self, "to_prev_level")
	Signal.on("s_fly_to_level", self, "fly_to_level")
	Signal.on("s_consume_block", self, "consume_block")
	Signal.on("s_consume_prop", self, "consume_prop")
	Signal.on("s_equip_bow", self, "equip_bow")
	Signal.on("s_unequip_bow", self, "unequip_bow")


func save_data() -> void:
	Data.save()


func reload_data() -> void:
	Data.reload_npc_config()


func back_to_main_menu() -> void:
	Data.save()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://ui/main/Main.tscn")


func to_level(path: String) -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene(path)


func to_next_level() -> void:
	var scene_tree = get_tree()
	var next_level_path = scene_tree.current_scene.next_level
	var next_level_scene = load(next_level_path)
	scene_tree.change_scene_to(next_level_scene)


func to_prev_level() -> void:
	var scene_tree = get_tree()
	var prev_level_path = scene_tree.current_scene.prev_level
	var prev_level_scene = load(prev_level_path)
	scene_tree.change_scene_to(prev_level_scene)


func fly_to_level(level: int) -> void:
	var level_str = "0%s" % level if level < 10 else "%s" % level
	var target_level_path = "res://scenes/level-%s/Level-%s.tscn" % [
		level_str,
		level_str,
	]
	# warning-ignore:return_value_discarded
	Util.change_scene(target_level_path)
	reset_pc_position()


func reset_pc_position() -> void:
	for portal in get_tree().get_nodes_in_group("g_portal"):
		if portal.type == portal.PortalType.DOWN:
			Signal.emit_signal("s_set_pc_position", portal.position)
			break


func consume_block(coord: Vector2, block_name: String) -> void:
	Data.set_consumed_block(Data.current_level, coord, block_name)


func consume_prop(prop_id: String) -> void:
	var block_names = Data.get_all_consumed_block_names()
	var prop_config = Data.get_prop_config_by_id(prop_id)
	take_effect(prop_id)
	if !(block_names.has(prop_id)):
		Signal.emit_signal("s_show_prop_message", prop_config)


func take_effect(prop_id: String) -> void:
	var prop_config = Data.get_prop_config_by_id(prop_id)
	if prop_config.is_collectible:
		var amount =  Data.get_inventory_amount_by_key(prop_id) + 1
		Data.set_inventory_amount_by_key(prop_id, amount)
	Data.pc_hp += prop_config.hp
	Data.pc_attack += prop_config.attack
	Data.pc_defence += prop_config.defence


func equip_bow() -> void:
	Signal.emit_signal("s_set_pc_visibility", false)
	bow.position = Data.pc_position
	add_child(bow)


func unequip_bow() -> void:
	Signal.emit_signal("s_set_pc_visibility", true)
	remove_child(bow)
