extends Node

export(int) var max_health = 1
onready var health = max_health setget setHealth

signal health_depleted

func setHealth(val):
	health = val
	if health <= 0:
		emit_signal("health_depleted")
	
