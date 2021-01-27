extends Node


const TEXT_DIALOG_SCENE = preload("res://ui/text-dialog/TextDialog.tscn")
const SELECT_DESTINATION_SCENE = preload("res://ui/select-destination/SelectDestination.tscn")
const GAME_SAVES_SCENE = preload("res://ui/game-saves/GameSaves.tscn")
const OPTION_DIALOG_SCENE = preload("res://ui/option-dialog/OptionDialog.tscn")
const MESSAGE_SCENE = preload("res://ui/message/Message.tscn")
const PAUSE_SCENE = preload("res://ui/pause/Pause.tscn")

const HINT = "[wave amp=10 freq=6]▼[/wave]"


func _ready() -> void:
	init_event()


func init_event() -> void:
	Signal.on("s_close_dialog", self, "close_dialog")
	Signal.on("s_remove_overlay", self, "remove_overlay")
	Signal.on("s_show_message", self, "show_message")
	Signal.on("s_show_prop_message", self, "show_prop_message")
	Signal.on("s_select_destination", self, "select_destination")
	Signal.on("s_show_epitaphs", self, "show_message")
	Signal.on("s_show_game_saves", self, "show_game_saves")
	Signal.on("s_show_options", self, "show_options")
	Signal.on("s_show_simple_message", self, "show_simple_message")
	Signal.on("s_show_pause_dialog", self, "show_pause_dialog")


func close_dialog() -> void:
	OverlayContainer.pop()


func remove_overlay(overlay: Node) -> void:
	OverlayContainer.remove(overlay)


func show_message(message: Array, actor: String = "") -> void:
	if !message.size():
		return
	var instance = TEXT_DIALOG_SCENE.instance()
	var lines = []
	for item in message:
		var line = "%s %s" % [item, HINT]
		lines.append(line)
	instance.lines = lines
	instance.actor_name = actor
	OverlayContainer.push(instance)


func show_prop_message(prop: Dictionary) -> void:
	var msg = "获得了%s %s" % [prop.name, HINT]
	var lines: Array = [msg]
	for desc in prop.description:
		lines.append("%s %s" % [desc, HINT])
	var instance = TEXT_DIALOG_SCENE.instance()
	instance.lines = lines
	OverlayContainer.push(instance)


func select_destination() -> void:
	var instance = SELECT_DESTINATION_SCENE.instance()
	OverlayContainer.push(instance)


func show_game_saves() -> void:
	var instance = GAME_SAVES_SCENE.instance()
	OverlayContainer.push(instance)


func show_options(line: String, options: Array) -> void:
	var instance = OPTION_DIALOG_SCENE.instance()
	instance.line = line
	instance.options = options
	OverlayContainer.push(instance)


func show_simple_message(message: String) -> void:
	var instance = MESSAGE_SCENE.instance()
	instance.message = message
	OverlayContainer.push(instance)


func show_pause_dialog() -> void:
	var instance = PAUSE_SCENE.instance()
	OverlayContainer.push(instance)
