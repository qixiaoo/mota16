extends TileMap


const FRAGILE_BLOCKS = [
	"tilemap.png 3",
	"tilemap.png 5",
	"tilemap.png 7",
	"tilemap.png 8",
]


var destroy_block: bool = false


func _ready() -> void:
	init_event()


func _unhandled_input(event: InputEvent) -> void:
	var m_event: InputEventMouse = event as InputEventMouse
	if !m_event || !destroy_block:
		return
	if m_event is InputEventMouseMotion:
		_mouse_motion()
	if (
		m_event is InputEventMouseButton &&
		m_event.is_pressed() &&
		!m_event.is_echo()
	):
		_destroy_block()


func init_event() -> void:
	Signal.on("s_show_destroy_block", self, "show_destroy_block")


func show_destroy_block() -> void:
	if destroy_block:
		return
	destroy_block = true
	Signal.emit_signal("s_set_pc_visibility", false)
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _mouse_motion() -> void:
	var tile_pos = world_to_map(get_viewport().get_mouse_position())
	var is_cell = get_cellv(tile_pos) != INVALID_CELL
	if is_cell:
		return
	var stove_tile_id = tile_set.find_tile_by_name("stove")
	clear()
	set_cellv(tile_pos, stove_tile_id)


func _destroy_block() -> void:
	clear()
	destroy_block = false
	Signal.emit_signal("s_set_pc_visibility", true)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	var tile_map: TileMap = get_parent()
	var tile_pos = world_to_map(get_viewport().get_mouse_position())
	if !_is_fragile_block(tile_pos):
		return
	tile_map.set_cellv(tile_pos, -1)


func _is_fragile_block(pos: Vector2) -> bool:
	var tile_map: TileMap = get_parent()
	var cell_id = tile_map.get_cellv(pos)
	if cell_id == TileMap.INVALID_CELL:
		return false
	var cell_name = tile_map.tile_set.tile_get_name(cell_id)
	return cell_name in FRAGILE_BLOCKS
