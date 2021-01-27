extends Area2D


export(String) var id: String = Data.EMPTY_STR
export(Array, String) var events: Array = []

export(bool) var one_shot: bool = true


func _on_Trigger_area_entered(area: Area2D) -> void:
	if !(one_shot && is_triggered()) && area.is_in_group("g_pc"):
		trigger_events()


func is_triggered() -> bool:
	return Data.get_extra_item(id) != Data.EMPTY_STR


func trigger_events() -> void:
	for event in events:
		Signal.emit(event)
	Data.set_extra_item(id, "true")
