tool
extends EditorPlugin


var calculator


func _enter_tree():
	calculator = preload("res://addons/calculator/Calculator.tscn").instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, calculator)


func _exit_tree():
	remove_control_from_docks(calculator)
	calculator.free()
