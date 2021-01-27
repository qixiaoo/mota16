extends TileMap


const NPC_SCENE = preload("res://objects/npc/NPC.tscn")


func init_map(consumed: Dictionary) -> void:
	instance_character(consumed) # 根据预设的 cell 实例化 npc
	clear() # 清除预设的 cell


func instance_character(consumed: Dictionary) -> void:
	var used_cells = get_used_cells()
	for position in used_cells:
		if String(position) in consumed:
			continue
		var cell_id = get_cell(position.x, position.y)
		var cell_name = tile_set.tile_get_name(cell_id)
		var is_x_flipped = is_cell_x_flipped(position.x, position.y)
		var npc = NPC_SCENE.instance()
		npc.npc_id = cell_name
		npc.flip_h = is_x_flipped
		npc.position = map_to_world(position) + cell_size / 2 
		add_child(npc)
