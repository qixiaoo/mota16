extends Level


func _ready() -> void:
	Signal.emit_signal("s_set_pc_visibility", false)


func _exit_tree() -> void:
	Signal.emit_signal("s_set_pc_visibility", true)
