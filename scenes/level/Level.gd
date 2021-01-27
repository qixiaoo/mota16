extends Node2D


class_name Level


export(int) var level = 0
export(String) var level_name = Data.EMPTY_STR

export(String, FILE, "*.tscn") var prev_level
export(String, FILE, "*.tscn") var next_level


onready var consumed_blocks = Data.get_consumed_blocks(level)
onready var npc_map = $NPCMap
onready var prop_map = $PropMap
onready var misc_map = $MiscMap


func _ready() -> void:
	Data.current_level = level
	add_to_group("g_level")
	npc_map.init_map(consumed_blocks)
	prop_map.init_map(consumed_blocks)
	misc_map.init_map(consumed_blocks)
	show_level_name()


func show_level_name() -> void:
	var lv_name
	if level_name != Data.EMPTY_STR:
		lv_name = level_name
	else:
		lv_name = "Level %s" % level
	Signal.emit_signal("s_show_simple_message", lv_name)
