extends Node


enum TaskStatus {
	TODO,
	IN_PROGRESS,
	DONE,
}


const EMPTY_DICT: Dictionary = {}
const EMPTY_STR: String = ""

const NPC_CONFIG_PATH = "res://assets/data/npc.json"
const PROP_CONFIG_PATH = "res://assets/data/prop.json"
const GAME_SCRIPT_PATH = "res://assets/data/script.json"

const GAME_DATA_PATH = "user://game_data.json"

const INIT_TASK = {
	"name": EMPTY_STR,
	"status": TaskStatus.TODO,
	"awarded": false
}

const INIT_USER_DATA = {
	"name": "",
	# todo: 初始三属性修改为 10, 10, 1000
	"attack": 10,
	"defence": 10,
	"hp": 1000,
	"gold": 0,
	"level": 0,
	"max_reached_level": 0,
	# todo: 初始位置修改为 200, 184
#	"position": [200, 72],
	"position": [200, 184],
#	"position": [120, 184],
	"inventory": {},
	"consumed_blocks": {},
	"extra_blocks": {},
	"tasks": {},
	"extra": {},
}

const INIT_GAME_DATA = {
	# todo: 修改 is_debug false
	"is_debug": true,
	"version": "0.1",
	"settings": {},
	"user_data": INIT_USER_DATA,
	"game_saves": [],
}


var npc_config: Dictionary setget set_npc_config, get_npc_config
var prop_config: Dictionary setget set_prop_config, get_prop_config
var game_script: Dictionary setget , get_game_script

var settings: Dictionary setget set_settings, get_settings
var user_data: Dictionary setget set_user_data, get_user_data
var game_saves: Array setget set_game_saves, get_game_saves

var pc_hp: float setget set_pc_hp, get_pc_hp
var pc_attack: float setget set_pc_attack, get_pc_attack
var pc_defence: float setget set_pc_defence, get_pc_defence
var pc_gold: float setget set_pc_gold, get_pc_gold
var pc_position: Vector2 setget set_pc_position, get_pc_position

var current_level: float setget set_current_level, get_current_level
var max_reached_level: float setget , get_max_reached_level

var inventory: Dictionary setget set_inventory, get_inventory


var _npc_config: Dictionary
var _prop_config: Dictionary
var _game_script: Dictionary

var _game_data: Dictionary


func _ready() -> void:
	_init_data()


func _init_data() -> void:
	var saved_data = Util.load_json(GAME_DATA_PATH)
	if saved_data == null:
		_game_data = INIT_GAME_DATA.duplicate(true)
	else:
		_game_data = saved_data
	
	_npc_config = Util.load_json(NPC_CONFIG_PATH)
	_prop_config = Util.load_json(PROP_CONFIG_PATH)
	_game_script = Util.load_json(GAME_SCRIPT_PATH)


# getter/setter


# warning-ignore:unused_argument
func set_npc_config(value: Dictionary) -> void:
	print("Cannot modify readonly property: npc_config.")


func get_npc_config() -> Dictionary:
	return _npc_config


# warning-ignore:unused_argument
func set_prop_config(value: Dictionary) -> void:
	print("Cannot modify readonly property: prop_config.")


func get_prop_config() -> Dictionary:
	return _prop_config


func get_game_script() -> Dictionary:
	return _game_script


func set_user_data(value: Dictionary) -> void:
	_game_data.user_data = value


func get_user_data() -> Dictionary:
	return _game_data.user_data


func set_settings(value: Dictionary) -> void:
	_game_data.settings = value


func get_settings() -> Dictionary:
	return _game_data.settings


func set_game_saves(value: Array) -> void:
	_game_data.game_saves = value


func get_game_saves() -> Array:
	return _game_data.game_saves


func set_pc_hp(value: float) -> void:
	_game_data.user_data.hp = value


func get_pc_hp() -> float:
	return _game_data.user_data.hp


func set_pc_attack(value: float) -> void:
	_game_data.user_data.attack = value


func get_pc_attack() -> float:
	return _game_data.user_data.attack


func set_pc_defence(value: float) -> void:
	_game_data.user_data.defence = value


func get_pc_defence() -> float:
	return _game_data.user_data.defence


func set_pc_gold(value: float) -> void:
	_game_data.user_data.gold = value


func get_pc_gold() -> float:
	return _game_data.user_data.gold


func set_pc_position(value: Vector2) -> void:
	_game_data.user_data.position = [value.x, value.y]


func get_pc_position() -> Vector2:
	var position = _game_data.user_data.position
	var vec2_pos = Vector2(position[0], position[1])
	return vec2_pos


func set_current_level(value: float) -> void:
	_game_data.user_data.level = value
	if _game_data.user_data.max_reached_level < value:
		_game_data.user_data.max_reached_level = value


func get_current_level() -> float:
	return _game_data.user_data.level


func get_max_reached_level() -> float:
	return _game_data.user_data.max_reached_level


func set_inventory(value: Dictionary) -> void:
	_game_data.user_data.inventory = value


func get_inventory() -> Dictionary:
	return _game_data.user_data.inventory


# 快捷方法


func reload_npc_config() -> void:
	_npc_config = Util.load_json(NPC_CONFIG_PATH)


func get_prop_config_by_id(prop_id: String) -> Dictionary:
	return _prop_config.get(prop_id)


func get_npc_config_by_id(npc_id: String) -> Dictionary:
	return _npc_config.get(npc_id)


func get_game_script_by_id(actor_id: String) -> Dictionary:
	return _game_script.get(actor_id)


func set_inventory_amount_by_key(key: String, amount: float) -> void:
	_game_data.user_data.inventory[key] = amount


func get_inventory_amount_by_key(key: String) -> float:
	return _game_data.user_data.inventory.get(key, 0)


func get_consumed_blocks(level: float) -> Dictionary:
	var level_key = String(level)
	return _game_data.user_data.consumed_blocks.get(level_key, {})


func get_all_consumed_block_names() -> Dictionary:
	var max_level = get_max_reached_level()
	var all_consumed_block_names: Dictionary = {}
	for level in range(max_level + 1):
		var consumed_blocks = get_consumed_blocks(level)
		var block_names = consumed_blocks.values()
		for block_name in block_names:
			if !all_consumed_block_names.has(block_name):
				all_consumed_block_names[block_name] = true
	return all_consumed_block_names


func set_consumed_block(
	level: float,
	coord: Vector2,
	block_name: String = ""
) -> void:
	var level_key = String(level)
	var blocks = _game_data.user_data.consumed_blocks.get(level_key, {})
	var coord_key = String(coord)
	blocks[coord_key] = block_name
	_game_data.user_data.consumed_blocks[level_key] = blocks


func get_extra_blocks(level: float) -> Dictionary:
	var level_key = String(level)
	return _game_data.user_data.extra_blocks.get(level_key, {})


func set_extra_block(
	level: float,
	coord: Vector2,
	block_name: String = ""
) -> void:
	var level_key = String(level)
	var blocks = _game_data.user_data.extra_blocks.get(level_key, {})
	var coord_key = String(coord)
	blocks[coord_key] = block_name
	_game_data.user_data.extra_blocks[level_key] = blocks


func has_task(task_id: String) -> bool:
	var task_dict: Dictionary = _game_data.user_data.tasks
	return task_dict.has(task_id)


func create_task(task_id: String) -> Dictionary:
	var task_dict: Dictionary = _game_data.user_data.tasks
	var task: Dictionary
	if task_dict.has(task_id):
		task = get_task_by_id(task_id)
	else:
		task = INIT_TASK.duplicate(true)
		task["name"] = task_id
	task_dict[task_id] = task
	return task


func get_task_by_id(task_id: String) -> Dictionary:
	var task_dict: Dictionary = _game_data.user_data.tasks
	var task: Dictionary = task_dict.get(task_id, EMPTY_DICT)
	if task == EMPTY_DICT:
		print("Task <%s> doesn't exist." % task_id)
		return EMPTY_DICT
	return task


func set_task_status_by_id(task_id: String, status: int) -> void:
	var task: Dictionary = get_task_by_id(task_id)
	task["status"] = status


func get_task_status_by_id(task_id: String) -> String:
	var task: Dictionary = get_task_by_id(task_id)
	return task.get("status", EMPTY_STR)


func set_task_awarded_by_id(task_id: String, awarded: bool) -> void:
	var task: Dictionary = get_task_by_id(task_id)
	task["awarded"] = awarded


func get_task_awarded_by_id(task_id: String) -> bool:
	var task: Dictionary = get_task_by_id(task_id)
	return task.get("awarded")


func set_extra_item(key: String, value: String) -> void:
	_game_data.user_data.extra[key] = value


func get_extra_item(key: String, default = EMPTY_STR) -> String:
	return _game_data.user_data.extra.get(key, default)


func is_debug() -> bool:
	return _game_data.is_debug


func save() -> void:
	Util.save_json(_game_data, GAME_DATA_PATH)


func create_game_save() -> void:
	# 深拷贝 Dictionary
	var json = JSON.print(_game_data.user_data)
	var new_save = parse_json(json)
	var date_template = "{year}.{month}.{day} {hour}.{minute}.{second}"
	var date_info = date_template.format(OS.get_datetime())
	var level_info = "Level %s" % get_current_level()
	new_save["name"] = "%s, %s" % [date_info, level_info]
	_game_data.game_saves.append(new_save)


func delete_game_save(index: int) -> void:
	_game_data.game_saves.remove(index)


func load_game_save(index: int) -> void:
	# 深拷贝 Dictionary
	var json = JSON.print(_game_data.game_saves[index])
	var new_save = parse_json(json)
	_game_data.user_data = new_save
