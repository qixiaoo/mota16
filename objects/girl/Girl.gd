extends StaticBody2D


const STATE = {
	"thank": "感谢",
}


var actor_id = "女孩"
var next_state = "thank"

var task_id = "save_the_girl"


# warning-ignore:unused_argument
func interact_with_pc(pc: Node) -> bool:
	talk()
	change_task_status()
	return true


func talk() -> void:
	var script = Data.get_game_script_by_id(actor_id)
	var lines = script.get(STATE[next_state])
	Signal.emit_signal("s_show_message", lines, actor_id)


func change_task_status() -> void:
	if !Data.has_task(task_id):
		# warning-ignore:return_value_discarded
		Data.create_task(task_id)
	if Data.get_task_status_by_id(task_id) != Data.TaskStatus.DONE:
		Data.set_task_status_by_id(task_id, Data.TaskStatus.DONE)
