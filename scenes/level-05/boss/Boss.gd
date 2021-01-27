extends NPC


const STATE = {
	"before-the-battle": "战斗前",
	"after-the-battle": "战斗后",
}


var actor_id = "骷髅女士[虚弱]"
var current_state: String = "before-the-battle"


func _ready() -> void:
	Signal.on("s_lv5_before_the_battle", self, "talk")
	Signal.on("s_lv5_after_the_battle", self, "talk")


func defeated() -> void:
	.defeated()
	current_state = "after-the-battle"
	Signal.emit("s_lv5_after_the_battle")
	Data.set_extra_item("lv5_boss_defeated", "true")


func talk(_params: Array) -> void:
	var script = Data.get_game_script_by_id(actor_id)
	var lines = script.get(STATE[current_state])
	Signal.emit_signal("s_show_message", lines, actor_id)
