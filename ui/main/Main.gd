extends CanvasLayer


onready var new_button: Button = $Panel/VBoxContainer/New
onready var continue_button: Button = $Panel/VBoxContainer/Continue
onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if Data.game_saves.empty():
		new_button.grab_focus()
	else:
		continue_button.grab_focus()


func _process(_delta: float) -> void:
	if Data.game_saves.empty():
		continue_button.disabled = false


func _on_New_pressed() -> void:
	var first_level = 0
	Data.set_user_data(Data.INIT_USER_DATA)
	Game.fly_to_level(first_level)


func _on_Continue_pressed() -> void:
	var current_level = int(Data.current_level)
	Game.fly_to_level(current_level)


func _on_Exit_pressed() -> void:
	get_tree().quit()


func _on_About_pressed() -> void:
	anim.play("show-detail")


func _on_Button_pressed() -> void:
	anim.play("hide-detail")


func _on_RichTextLabel_meta_clicked(meta) -> void:
	# warning-ignore:return_value_discarded
	OS.shell_open(meta)
