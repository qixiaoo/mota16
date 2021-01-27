extends Level


onready var boss = $Boss
onready var portal = $Portal


func _ready() -> void:
	init_event()
	init_stage()


func init_event() -> void:
	Signal.on("s_lv5_before_the_battle", self, "prepare_stage")
	Signal.on("s_lv5_after_the_battle", self, "reset_stage")


func init_stage() -> void:
	if Data.get_extra_item("lv5_boss_defeated") != Data.EMPTY_STR:
		boss.visible = false
		boss.queue_free()
	if Data.get_extra_item("lv5_hide_portal") != Data.EMPTY_STR:
		hide_portal()


func prepare_stage(_params: Array) -> void:
	hide_portal()
	Data.set_extra_item("disable_fly", "true")
	Data.set_extra_item("lv5_hide_portal", "true")


func reset_stage(_params: Array) -> void:
	Data.set_extra_item("disable_fly", Data.EMPTY_STR)
	Data.set_extra_item("lv5_hide_portal", Data.EMPTY_STR)


func hide_portal() -> void:
	portal.visible = false
	portal.collision_layer = 0
	portal.collision_mask = 0
