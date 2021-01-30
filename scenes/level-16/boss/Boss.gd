extends NPC


const STATE = {
	"before-the-battle": "战斗前",
	"after-the-battle": "战斗后",
}


var actor_id = "骷髅女士"
var current_state: String = "before-the-battle"


func _ready() -> void:
	Signal.on("s_lv16_before_the_battle", self, "talk")
	Signal.on("s_lv16_after_the_battle", self, "talk")


func defeated() -> void:
	visible = false
	Data.pc_hp -= damage_to_pc
	Data.pc_gold += npc_config.get("gold")
	current_state = "after-the-battle"
	Signal.emit("s_lv16_after_the_battle")
	yield(Signal, "s_close_dialog")
	Signal.emit_signal("s_back_to_main_menu")
	Data.set_extra_item("lv16_boss_defeated", "true")


func talk(_params: Array) -> void:
	var script = Data.get_game_script_by_id(actor_id)
	var lines = script.get(STATE[current_state])
	Signal.emit_signal("s_show_message", lines, actor_id)
