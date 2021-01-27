extends Area2D


enum BlockType {
	UNKNOWN,
	EMPTY,
	TILE,
	INTERACTIVE,
	DOOR,
	ENEMY,
	NEUTRAL,
	PROP,
	PORTAL,
	TOMBSTONE,
}


export(int) var defence
export(int) var attack

# disable collision
export(bool) var disabled = false setget set_disabled, get_disabled


onready var shape: CollisionShape2D = $CollisionShape2D
onready var ray: RayCast2D = $RayCast2D
onready var sprite: Sprite = $Sprite
onready var anim_player: AnimationPlayer = $AnimationPlayer


var tile_size = 16
var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN,
}

var ghost_form = false setget set_ghost_form


func _ready() -> void:
	position = Data.pc_position
	set_disabled(disabled)
	init_event()


func _unhandled_key_input(event: InputEventKey) -> void:
	for dir in inputs.keys():
		if event.is_action(dir) && event.is_pressed():
			action_round(dir)


func _exit_tree() -> void:
	unbind_event()


func init_event() -> void:
	Signal.on("s_freeze_pc", self, "freeze_pc")
	Signal.on("s_set_pc_position", self, "set_pc_position")
	Signal.on("s_set_pc_visibility", self, "set_pc_visibility")
	Signal.on("s_ghost_form", self, "set_ghost_form")


func unbind_event() -> void:
	Signal.off("s_set_pc_position", self, "set_pc_position")
	Signal.off("s_set_pc_visibility", self, "set_pc_visibility")
	Signal.off("s_ghost_form", self, "set_ghost_form")


func action_round(dir: String) -> void:
	turn_around(dir)
	ray.position = inputs[dir] * tile_size / 2
	ray.cast_to = inputs[dir] * tile_size / 2
	ray.force_raycast_update()
	var collider = ray.get_collider()
	var block_type = get_collider_type(collider)
	match block_type:
		BlockType.INTERACTIVE:
			if ghost_form:
				var is_portal = collider.is_in_group("g_portal")
				var is_tombstone = collider.is_in_group("g_tombstone")
				if is_tombstone || is_portal:
					move(dir)
			else:
				var is_blocked = collider.interact_with_pc(self)
				if !is_blocked:
					move(dir)
		BlockType.EMPTY:
			move(dir)


func get_collider_type(collider: Object) -> int:
	if collider == null:
		return BlockType.EMPTY
	elif collider is TileMap:
		return BlockType.TILE
	elif collider is Node && collider.is_in_group("g_interactive"):
		return BlockType.INTERACTIVE
	else:
		return BlockType.UNKNOWN


func turn_around(dir: String) -> void:
	if dir == "ui_left":
		sprite.scale.x = 1
	if dir == "ui_right":
		sprite.scale.x = -1


func move(dir: String) -> void:
	position += inputs[dir] * tile_size
	Data.pc_position = position


func set_disabled(value: bool) -> void:
	disabled = value
	if !shape || !ray:
		return
	shape.disabled = value
	ray.collision_mask = 0 if value else 1


func get_disabled() -> bool:
	return disabled


func set_ghost_form(value: bool) -> void:
	ghost_form = value
	if !shape || !ray || !sprite:
		return
	var anim = "ghost" if ghost_form else "idle"
	anim_player.play(anim)


func freeze_pc(is_disabled: bool) -> void:
	set_process_unhandled_key_input(!is_disabled)


func set_pc_position(pos: Vector2) -> void:
	position = pos
	Data.pc_position = pos


func set_pc_visibility(is_visible: bool) -> void:
	visible = is_visible
	set_disabled(!is_visible)
	set_process_unhandled_key_input(is_visible)
