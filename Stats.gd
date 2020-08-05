extends Node

export(int) var max_health = 1 setget set_max_health
onready var health = max_health setget set_health

signal health_depleted
signal health_changed
signal max_health_changed

func _ready():
	health = min(health,max_health)

func set_max_health(val):
	max_health = max(1,val)
	emit_signal("max_health_changed",max_health)

func set_health(val):
	health = min(val,max_health)
	emit_signal("health_changed",health)
	if health <= 0:
		emit_signal("health_depleted")
	

