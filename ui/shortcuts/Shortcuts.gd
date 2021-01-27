extends Panel


func _on_SaveButton_pressed():
	Signal.emit_signal("s_show_game_saves")


func _on_PauseButton_pressed():
	Signal.emit_signal("s_show_pause_dialog")


func _on_ResetButton_pressed():
	if Data.is_debug():
		Signal.emit_signal("s_reload_data")
