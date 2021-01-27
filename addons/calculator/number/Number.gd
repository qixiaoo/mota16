tool
extends HBoxContainer


export(String) var label setget set_label, get_label
export(float, 0, 9999999, 1) var value setget set_value, get_value


onready var label_node = $Label
onready var value_node = $Value


func _ready() -> void:
	set_label(label)
	set_value(value)


func set_label(label_value: String) -> void:
	label = label_value
	
	if !label_node:
		return
	
	label_node.text = label


func get_label() -> String:
	return label


func set_value(value_value: float) -> void:
	value = value_value
	
	if !value_node:
		return
	
	value_node.value = value


func get_value() -> float:
	if !value_node:
		return 0.0
	
	return value_node.value
