extends Level


onready var dino: StaticBody2D = $Dinosaur
onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	init_event()
	init_stage()


func init_event() -> void:
	Signal.on("s_lv10_leave", self, "leave")


func init_stage() -> void:
	if Data.get_extra_item("lv10_dino_left") != Data.EMPTY_STR:
		dino.visible = false
		dino.queue_free()


func leave(_params: Array = []) -> void:
	Signal.emit_signal("s_freeze_pc", true)
	anim.play("darken")
	yield(anim, "animation_finished")
	Data.set_extra_item("lv10_dino_left", "true")
	dino.queue_free()
	audio.play()
	yield(audio, "finished")
	anim.play("brighten")
	yield(anim, "animation_finished")
	Signal.emit_signal("s_freeze_pc", false)
