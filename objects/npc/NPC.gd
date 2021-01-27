extends StaticBody2D


class_name NPC


export(String) var npc_id
export(bool) var flip_h = false


onready var sprite: Sprite = $Sprite
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var damage_label: RichTextLabel = $DamageLabel


var npc_config: Dictionary
var damage_to_pc: float


func _ready() -> void:
	npc_config = Data.get_npc_config_by_id(npc_id)
	sprite.flip_h = flip_h
	add_to_group(npc_config.get("group"))
	set_idle_animation()


func _process(_delta: float) -> void:
	if is_in_group("g_enemy"):
		compute_damage()
		update_damage_label()


func set_idle_animation() -> void:
	var anim = anim_player.get_animation("idle")
	var frame_track_idx = anim.find_track("Sprite:frame")
	var first_frame = npc_config.get("frame")
	anim.track_set_key_value(frame_track_idx, 0, first_frame)
	anim.track_set_key_value(frame_track_idx, 1, first_frame + 1)


func compute_damage() -> void:
	var pc_list = get_tree().get_nodes_in_group("g_pc")
	if !pc_list || !pc_list.size():
		return
	damage_to_pc = Util.compute_damage(
		npc_config.get("attack"),
		npc_config.get("defence"),
		npc_config.get('hp'),
		Data.pc_attack,
		Data.pc_defence
	)


func update_damage_label() -> void:
	var bbcode_text: String
	var template = "[center][color={color}]{damage}[/color][/center]"
	var thresholds = [0.3 * Data.pc_hp, 0.6 * Data.pc_hp]
	
	if damage_to_pc < thresholds[0]:
		bbcode_text = template.format({"color": "green", "damage": damage_to_pc})
	elif damage_to_pc >= thresholds[0] && damage_to_pc <= thresholds[1]:
		bbcode_text = template.format({"color": "yellow", "damage": damage_to_pc})
	elif damage_to_pc > thresholds[1] && damage_to_pc < INF:
		bbcode_text = template.format({"color": "red", "damage": damage_to_pc})
	else:
		bbcode_text = template.format({"color": "red", "damage": "????"})
	
	damage_label.bbcode_text = bbcode_text


# warning-ignore:unused_argument
func interact_with_pc(pc: Node) -> bool:
	var block_pc = Data.pc_hp <= damage_to_pc
	if !block_pc:
		defeated()
	return block_pc


func defeated() -> void:
	var parent = get_parent()
	if parent is TileMap:
		var coordinate = parent.world_to_map(position)
		Signal.emit_signal("s_consume_block", coordinate, npc_id)
	else:
		print("NPC should be instantiated by NPCMap.")
	
	Data.pc_hp -= damage_to_pc
	Data.pc_gold += npc_config.get("gold")
	queue_free()
