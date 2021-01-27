extends RigidBody2D


# warning-ignore:unused_argument
func _on_Arrow_body_entered(body: Node) -> void:
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
