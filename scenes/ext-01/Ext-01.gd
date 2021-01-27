extends Level


const LV9_SCENE_PATH = "res://scenes/level-09/Level-09.tscn" 


onready var tile_map: TileMap = $TileMap


func _ready() -> void:
	Signal.on("s_back_to_lv9", self, "back_to_lv9")
	Signal.emit_signal("s_set_pc_visibility", false)


func _exit_tree() -> void:
	Signal.emit_signal("s_set_pc_visibility", true)


func back_to_lv9(_params: Array = []) -> void:
	var pos = tile_map.map_to_world(Vector2(7, 11)) + tile_map.cell_size / 2
	Signal.emit_signal("s_to_level", LV9_SCENE_PATH)
	Signal.emit_signal("s_set_pc_position", pos)
