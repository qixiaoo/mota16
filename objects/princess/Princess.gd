extends Node2D


onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	Signal.on("s_lv2_exception", self, "exception")


func exception(_params: Array) -> void:
	audio.play()
	anim.play("exception")
	yield(anim, "animation_finished")
	anim.play("idle")
