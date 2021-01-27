extends TileMap


const ICE_TILE_NAME = "Terrain:ICE"
const LAVA_TILE_NAME = "Terrain:LAVA"


var create_ice: bool = false


func _ready() -> void:
	init_event()


func _unhandled_input(event: InputEvent) -> void:
	var m_event: InputEventMouse = event as InputEventMouse
	if !m_event || !create_ice:
		return
	if m_event is InputEventMouseMotion:
		_mouse_motion()
	if (
		m_event is InputEventMouseButton &&
		m_event.is_pressed() &&
		!m_event.is_echo()
	):
		_create_ice()


func init_event() -> void:
	Signal.on("s_show_create_ice", self, "show_create_ice")


func show_create_ice() -> void:
	if create_ice:
		return
	create_ice = true
	Signal.emit_signal("s_set_pc_visibility", false)
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _mouse_motion() -> void:
	var tile_pos = world_to_map(get_viewport().get_mouse_position())
	var is_cell = get_cellv(tile_pos) != INVALID_CELL
	if is_cell:
		return
	var ice_tile_id = tile_set.find_tile_by_name("ice")
	clear()
	set_cellv(tile_pos, ice_tile_id)


func _create_ice() -> void:
	clear()
	create_ice = false
	Signal.emit_signal("s_set_pc_visibility", true)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	var tile_pos = world_to_map(get_viewport().get_mouse_position())
	var lava_block = _get_lava_block(tile_pos)
	if !lava_block:
		return
	lava_block.queue_free()
	_create_ice_block(tile_pos)


func _get_lava_block(pos: Vector2) -> Node2D:
	var misc_map: TileMap = get_parent()
	var lava_block: Node2D
	var lava_block_pos = map_to_world(pos) + cell_size / 2
	for child in misc_map.get_children():
		var is_lava = child is Terrain && child.type == child.TerrainType.LAVA
		if is_lava && (child as Node2D).position == lava_block_pos:
			lava_block = child
			break
	return lava_block


func _create_ice_block(coord: Vector2) -> void:
	var misc_map: TileMap = get_parent()
	var tile_id = misc_map.tile_set.find_tile_by_name(ICE_TILE_NAME)
	misc_map.set_cellv(coord, tile_id)
