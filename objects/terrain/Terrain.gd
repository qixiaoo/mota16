extends StaticBody2D


class_name Terrain


enum TerrainType { LAVA, ICE, WATER, DARK, }


export(TerrainType) var type = TerrainType.LAVA setget set_type, get_type


onready var anim_sprite: AnimatedSprite = $AnimatedSprite


func _ready() -> void:
	set_type(type)


func set_type(value: int) -> void:
	type = value
	
	if !anim_sprite:
		return
	
	match type:
		TerrainType.LAVA:
			anim_sprite.animation = "lava"
		TerrainType.ICE:
			anim_sprite.animation = "ice"
		TerrainType.WATER:
			anim_sprite.animation = "water"
		TerrainType.DARK:
			anim_sprite.animation = "dark"


func get_type() -> int:
	return type
