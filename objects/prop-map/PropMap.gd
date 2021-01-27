extends TileMap


const PROP_SCENE = preload("res://objects/prop/Prop.tscn")


func init_map(consumed: Dictionary) -> void:
	instance_prop(consumed) # 根据预设的 cell 实例化 prop
	clear() # 清除预设的 cell


func instance_prop(consumed: Dictionary) -> void:
	var used_cells = get_used_cells()
	for position in used_cells:
		if String(position) in consumed:
			continue
		var cell_id = get_cell(position.x, position.y)
		var cell_name = tile_set.tile_get_name(cell_id)
		var prop = PROP_SCENE.instance()
		prop.prop_id = cell_name
		prop.position = map_to_world(position) + cell_size / 2
		add_child(prop)
