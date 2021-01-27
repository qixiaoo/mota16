extends VBoxContainer


onready var hp = $Property/HPValue
onready var attack = $Property/AttackValue
onready var defence = $Property/DefenceValue
onready var gold = $Property/GoldValue

onready var copper_key = $Key/CopperKeyNumber
onready var sapphire_key = $Key/SapphireKeyKeyNumber
onready var ruby_key = $Key/RubyKeyNumber

onready var wing = $Other/RodOfWingNumber
onready var wing_button = $Other/RodOfWingButton
onready var ghost_pipe = $Other/GhostNumber
onready var ghost_pipe_button = $Other/GhostPipeButton
onready var bow = $Other/BowNumber
onready var bow_button = $Other/BowButton
onready var ice = $Other/IceNumber
onready var ice_button = $Other/IceButton
onready var stove = $Other/StoveNumber
onready var stove_button = $Other/StoveButton


func _process(_delta: float) -> void:
	hp.text = String(Data.pc_hp)
	attack.text = String(Data.pc_attack)
	defence.text = String(Data.pc_defence)
	gold.text = String(Data.pc_gold)
	
	copper_key.text = String(Data.get_inventory_amount_by_key("黄钥匙"))
	sapphire_key.text = String(Data.get_inventory_amount_by_key("蓝钥匙"))
	ruby_key.text = String(Data.get_inventory_amount_by_key("红钥匙"))
	
	wing.text = String(Data.get_inventory_amount_by_key("飞行器"))
	ghost_pipe.text = String(Data.get_inventory_amount_by_key("幽灵烟斗"))
	bow.text = String(Data.get_inventory_amount_by_key("木之弓"))
	ice.text = String(Data.get_inventory_amount_by_key("雪之徽章"))
	stove.text = String(Data.get_inventory_amount_by_key("木之镐"))


func _on_RodOfWingButton_pressed() -> void:
	var disabled = Data.get_extra_item("disable_fly")
	if (wing.text != "0" || Data.is_debug()) && !disabled:
		Signal.emit_signal("s_select_destination")


func _on_GhostPipeButton_pressed() -> void:
	var disabled = Data.get_extra_item("disable_ghost_pipe")
	if (ghost_pipe.text != "0" || Data.is_debug()) && !disabled:
		if ghost_pipe_button.pressed:
			wing_button.disabled = true
			bow_button.disabled = true
			Signal.emit_signal("s_ghost_form", true)
		else:
			wing_button.disabled = false
			bow_button.disabled = false
			Signal.emit_signal("s_ghost_form", false)


func _on_BowButton_pressed() -> void:
	var disabled = Data.get_extra_item("disable_bow")
	if (ghost_pipe.text != "0" || Data.is_debug()) && !disabled:
		if bow_button.pressed:
			wing_button.disabled = true
			ghost_pipe_button.disabled = true
			Signal.emit_signal("s_equip_bow")
		else:
			wing_button.disabled = false
			ghost_pipe_button.disabled = false
			Signal.emit_signal("s_unequip_bow")


func _on_IceButton_pressed() -> void:
	var disabled = Data.get_extra_item("disable_ice")
	if (ice.text != "0" || Data.is_debug()) && !disabled:
		Signal.emit_signal("s_show_create_ice")


func _on_StoveButton_pressed() -> void:
	var disabled = Data.get_extra_item("disable_stove")
	if (ice.text != "0" || Data.is_debug()) && !disabled:
		Signal.emit_signal("s_show_destroy_block")
