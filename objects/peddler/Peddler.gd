extends StaticBody2D


const DEFAULT_PRICE = 20


var actor_id = "商人"

var price_key = "current_price"

var attack_augment = 3
var defence_augment = 6
var life_augment = 500


# warning-ignore:unused_argument
func interact_with_pc(pc: Node) -> bool:
	var block_pc = true
	sell()
	return block_pc


func sell() -> void:
	var current_price = int(Data.get_extra_item(price_key, String(DEFAULT_PRICE)))
	var line = "欢迎光臨, 每件商品 %s 金币" % current_price
	var options = [
		"攻击 +%s" % attack_augment,
		"防御 +%s" % defence_augment,
		"生命 +%s" % life_augment,
		"离开",
	]
	Signal.emit_signal("s_show_options", line, options)
	
	if !Signal.has_user_signal("s_select_option"):
		Signal.add_user_signal("s_select_option")
	
	var selected = yield(Signal, "s_select_option")
	if selected == 3:
		return
	
	if current_price > Data.pc_gold:
		Signal.emit_signal("s_show_message", ["抱歉, 您的金币数量不足"], actor_id)
	else:
		Data.set_extra_item(price_key, String(current_price * 2))
		Data.pc_gold -= current_price
		if selected == 0:
			Data.pc_attack += attack_augment
		if selected == 1:
			Data.pc_defence += defence_augment
		if selected == 2:
			Data.pc_hp += life_augment
