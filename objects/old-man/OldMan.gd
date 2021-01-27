extends StaticBody2D


const STATE = {
	"request": "请求",
	"introduction": "介绍",
	"award": "奖励",
	"thank": "感谢",
}


var actor_id = "老人"
var current_state: String

var task_id = "save_the_girl"
var task_reward = "幽灵烟斗"


func _ready() -> void:
	if !Data.has_task(task_id):
		# warning-ignore:return_value_discarded
		Data.create_task(task_id)


# warning-ignore:unused_argument
func interact_with_pc(pc: Node) -> bool:
	change_state()
	talk()
	yield(Signal, "s_close_dialog")
	try_award()
	return true


func change_state() -> void:
	var task_status = Data.get_task_status_by_id(task_id)
	var task_awarded = Data.get_task_awarded_by_id(task_id)
	if task_status != Data.TaskStatus.DONE:
		current_state = "request" if current_state != "request" else "introduction"
	else:
		current_state = "thank" if task_awarded == true else "award"


func talk() -> void:
	var script = Data.get_game_script_by_id(actor_id)
	var lines = script.get(STATE[current_state])
	Signal.emit_signal("s_show_message", lines, actor_id)


func try_award() -> void:
	var task_status = Data.get_task_status_by_id(task_id)
	var task_awarded = Data.get_task_awarded_by_id(task_id)
	if task_status == Data.TaskStatus.DONE && task_awarded == false:
		Data.set_task_awarded_by_id(task_id, true)
		Signal.emit_signal("s_consume_prop", task_reward)
