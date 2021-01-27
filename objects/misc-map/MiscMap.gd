extends TileMap


const DOOR_SCENE = preload("res://objects/door/Door.tscn")
const PORTAL_SCENE = preload("res://objects/portal/Portal.tscn")
const TERRAIN_SCENE = preload("res://objects/terrain/Terrain.tscn")


const SCENE_MAP: Dictionary = {
	"Door": DOOR_SCENE,
	"Portal": PORTAL_SCENE,
	"Terrain": TERRAIN_SCENE
}


func init_map(consumed: Dictionary) -> void:
	instance_scene(consumed) # 根据预设的 cell 实例化 scene
	clear() # 清除预设的 cell


func instance_scene(consumed: Dictionary) -> void:
	var used_cells = get_used_cells()
	for position in used_cells:
		if String(position) in consumed:
			continue
		var cell_id = get_cell(position.x, position.y)
		var cell_name = tile_set.tile_get_name(cell_id)
		var scene_key = cell_name.split(":")[0]
		var scene_type = cell_name.split(":")[1]
		var instance = SCENE_MAP.get(scene_key).instance()
		# 简单起见硬编码处理了
		instance.type = instance[scene_key + "Type"][scene_type]
		instance.position = map_to_world(position) + cell_size / 2
		add_child(instance)
		move_child(instance, 0)
