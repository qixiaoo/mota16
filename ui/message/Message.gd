extends Control


const DURATION = 2
const INIT_COLOR = Color8(255, 255, 255, 0)
const FINAL_COLOR = Color8(255, 255, 255, 255)
const TRANS_DURATION = 0.3


export(String, MULTILINE) var message: String = Data.EMPTY_STR


onready var panel_container: PanelContainer = $PanelContainer
onready var label: Label = $PanelContainer/MarginContainer/Label
onready var tween: Tween = $Tween


func _ready() -> void:
	label.text = message
	modulate = INIT_COLOR
	yield(get_tree(), "idle_frame")
	_show()
	yield(tween, "tween_all_completed")
	yield(get_tree().create_timer(DURATION), "timeout")
	_hide()
	yield(tween, "tween_all_completed")
	Signal.emit_signal("s_remove_overlay", self)


func _show() -> void:
	# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self,
		"rect_position",
		Vector2(0, -rect_size.y),
		Vector2(0, 0),
		TRANS_DURATION,
		Tween.TRANS_CUBIC
	)
	# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self,
		"modulate",
		INIT_COLOR,
		FINAL_COLOR,
		TRANS_DURATION,
		Tween.TRANS_CUBIC
	)
	# warning-ignore:return_value_discarded
	tween.start()


func _hide() -> void:
	# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self,
		"rect_position",
		Vector2(0, 0),
		Vector2(0, -rect_size.y),
		TRANS_DURATION,
		Tween.TRANS_CUBIC
	)
	# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self,
		"modulate",
		FINAL_COLOR,
		INIT_COLOR,
		TRANS_DURATION,
		Tween.TRANS_CUBIC
	)
	# warning-ignore:return_value_discarded
	tween.start()
