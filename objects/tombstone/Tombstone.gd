extends StaticBody2D


export(Array, String, MULTILINE) var epitaphs: Array = []


# warning-ignore:unused_argument
func interact_with_pc(pc: Node) -> bool:
	Signal.emit_signal("s_show_epitaphs", epitaphs)
	return true
