tool
extends PanelContainer


const PC_DATA_PATH = "res://addons/calculator/data/pc-data.json"
const NPC_DATA_PATH = "res://assets/data/npc.json"
const NPC_SCENE = preload("res://addons/calculator/npc/NPC.tscn")


onready var container = $ScrollContainer/VBoxContainer


var pc_data: Dictionary
var npc_data: Dictionary


func _ready() -> void:
	var schema_key = "$schema"
	pc_data = load_json(PC_DATA_PATH)
	npc_data = load_json(NPC_DATA_PATH)
	
	for key in npc_data:
		if key == schema_key:
			continue
		
		var npc = NPC_SCENE.instance()
		npc.npc_data = npc_data[key]
		
		if !pc_data.has(key):
			pc_data[key] = { "attack": 10, "defence": 10, "hp": 1000 }
		npc.pc_data = pc_data[key]
		
		container.add_child(npc)


func _on_SaveButton_pressed():
	save_json(pc_data, PC_DATA_PATH)
	save_json(npc_data, NPC_DATA_PATH)


func load_json(path: String):
	var file: File = File.new()
	if not file.file_exists(path):
		print("JSON file <%s> doesn't exist." % path)
		return null
	
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	return parse_json(content)


func save_json(dict: Dictionary, path: String):
	var file = File.new()
	file.open(path, File.WRITE)
	var content = JSON.print(dict, "    ")
	file.store_string(content)
	file.close()
