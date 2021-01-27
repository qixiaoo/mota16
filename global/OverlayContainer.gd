extends CanvasLayer


onready var scene_tree = get_tree()
onready var root = get_tree().root


var bottom_layer_value: int = 1 # 默认 2D 场景所在 layer 为 0

var layer_stack: Array = []


func _ready() -> void:
	layer = bottom_layer_value
	scene_tree.connect(
		"tree_changed",
		self,
		"_on_tree_changed",
		[],
		CONNECT_DEFERRED
	)


func _on_tree_changed() -> void:
	# overlay container 始终作为 root 的最后一个节点，
	# 以确保内部的 overlay 能先于场景中其他节点收到 input 事件
	var last_child_index = root.get_child_count() - 1
	var last_child = root.get_child(last_child_index)
	if self != last_child:
		root.move_child(self, last_child_index)


func _push_layer(overlay: Node) -> void:
	var layer: CanvasLayer = CanvasLayer.new()
	var top_layer_value = bottom_layer_value + 1
	if !layer_stack.empty():
		var top_layer: CanvasLayer = layer_stack[layer_stack.size() - 1]
		top_layer_value = top_layer.layer + 1
	layer.layer = top_layer_value
	layer_stack.push_back(layer)
	layer.add_child(overlay)
	add_child(layer)


func _pop_layer() -> void:
	if layer_stack.empty():
		return
	var layer: CanvasLayer = layer_stack.pop_back()
	layer.queue_free()


func _remove_layer(overlay: Node) -> void:
	if layer_stack.empty():
		return
	for layer in get_children():
		if layer.get_child(0) == overlay:
			layer_stack.erase(layer)
			layer.queue_free()
			break


func push(overlay: Node) -> void:
	_push_layer(overlay)


func pop() -> void:
	_pop_layer()


func remove(overlay: Node) -> void:
	_remove_layer(overlay)
