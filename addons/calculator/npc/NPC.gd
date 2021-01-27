tool
extends GridContainer


export(Dictionary) var pc_data
export(Dictionary) var npc_data


onready var pc_attack = $PCAttack
onready var pc_defence = $PCDefence
onready var pc_hp = $PCHP

onready var enemy_attack = $EnemyAttack
onready var enemy_defence = $EnemyDefence
onready var enemy_hp = $EnemyHP

onready var name_node = $Name
onready var damage: Label = $Damage

onready var gold = $Gold


func _ready() -> void:
	name_node.text = npc_data.name
	enemy_attack.value = npc_data.attack
	enemy_defence.value = npc_data.defence
	enemy_hp.value = npc_data.hp
	
	pc_attack.value = pc_data.attack
	pc_defence.value = pc_data.defence
	pc_hp.value = pc_data.hp
	
	gold.value = npc_data.get("gold", 0)


func _process(delta: float) -> void:
	var result = compute_damage(
		enemy_attack.value,
		enemy_defence.value,
		enemy_hp.value,
		pc_attack.value,
		pc_defence.value
	)
	set_damage(result)
	update_data()


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


func set_damage(result: float) -> void:
	var hp = pc_hp.value
	var thresholds = [0.3 * hp, 0.6 * hp]
	if result < thresholds[0]:
		damage.modulate = Color( 0.13, 0.55, 0.13, 1 )
	elif result >= thresholds[0] && result <= thresholds[1]:
		damage.modulate = Color( 1, 0.55, 0, 1 )
	else:
		damage.modulate = Color( 0.86, 0.08, 0.24, 1 )
	damage.text = "%s" % result


func update_data() -> void:
	npc_data["attack"] = enemy_attack.value
	npc_data["defence"] = enemy_defence.value
	npc_data["hp"] = enemy_hp.value
	
	npc_data["gold"] = gold.value
	
	pc_data["attack"] = pc_attack.value
	pc_data["defence"] = pc_defence.value
	pc_data["hp"] = pc_hp.value
