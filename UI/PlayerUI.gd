extends Control

var stats = PlayerStats
onready var ph_empty = $PlayerHeartsEmpty
onready var ph_full = $PlayerHeartsFull

func _ready():
	stats.connect("health_changed",self,"change_health")
	stats.connect("max_health_changed",self,"change_max_health")
	change_health(stats.health)
	change_max_health(stats.max_health)
	
func change_health(val):
	ph_full.rect_size.x = 15*val
	pass
	
func change_max_health(val):
	ph_empty.rect_size.x = 15*val
	pass
