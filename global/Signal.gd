extends Node


func on(
	user_signal: String,
	target: Object,
	method: String,
	binds: Array = [  ],
	flags: int = 0
) -> void:
	if !has_user_signal(user_signal):
		add_user_signal(user_signal)
	# warning-ignore:return_value_discarded
	connect(user_signal, target, method, binds, flags)


func off(user_signal: String, target: Object, method: String) -> void:
	if is_connected(user_signal, target, method):
		disconnect(user_signal, target, method)


func emit(user_signal: String, binds: Array = []) -> void:
	if !has_user_signal(user_signal):
		add_user_signal(user_signal)
	emit_signal(user_signal, binds)
