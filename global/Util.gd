extends Node


func load_json(path: String):
	var file: File = File.new()
	if not file.file_exists(path):
		print("JSON file <%s> doesn't exist." % path)
		return null
	
	# warning-ignore:return_value_discarded
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	return parse_json(content)


func save_json(dict: Dictionary, path: String):
	var file = File.new()
	file.open(path, File.WRITE)
	var content = to_json(dict)
	file.store_string(content)
	file.close()


# 同步地切换到新场景并返回新场景的实例
func change_scene(path: String) -> Node:
	var scene_tree = get_tree()
	var new_scene = (load(path) as PackedScene).instance()
	var prev_scene = scene_tree.current_scene
	scene_tree.root.remove_child(prev_scene)
	scene_tree.root.add_child(new_scene)
	scene_tree.current_scene = new_scene
	prev_scene.queue_free()
	return new_scene


func compute_damage(
	enemy_attack: float,
	enemy_defence: float,
	enemy_hp: float,
	pc_attack: float,
	pc_defence: float
) -> float:
	if pc_attack <= enemy_defence:
		return INF
	elif enemy_attack <= pc_defence:
		return 0.0
	else:
		var rounds = ceil(enemy_hp / (pc_attack - enemy_defence))
		return (rounds - 1) * (enemy_attack - pc_defence)
