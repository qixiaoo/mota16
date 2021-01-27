extends Level


const EXT_01_SCENE_PATH = "res://scenes/ext-01/Ext-01.tscn"


func _ready() -> void:
	init_event()


func init_event() -> void:
	Signal.on("s_lv9_enter_ext_01", self, "enter_ext_01")


func enter_ext_01(_params: Array = []) -> void:
	Signal.emit_signal("s_to_level", EXT_01_SCENE_PATH)
