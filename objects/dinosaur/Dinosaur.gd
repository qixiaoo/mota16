extends StaticBody2D


const STATE = {
	"request": "请求",
	"thank": "感谢",
}


var actor_id = "蒂諾"
var current_state: String = "request"


func _ready() -> void:
	Signal.on("s_chat_with_dino", self, "talk")


# warning-ignore:unused_argument
func interact_with_pc(pc: Node) -> bool:
	current_state = "thank"
	talk()
	yield(Signal, "s_close_dialog")
	Signal.emit("s_lv10_leave")
	return true


func talk(_params: Array = []) -> void:
	var script = Data.get_game_script_by_id(actor_id)
	var lines = script.get(STATE[current_state])
	Signal.emit_signal("s_show_message", lines, actor_id)
