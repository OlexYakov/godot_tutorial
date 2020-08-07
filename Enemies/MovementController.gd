extends Node2D

export(int) var wander_range = 32

onready var timer = $Timer

onready var start_position = global_position
onready var target_position = next_wander_position()

signal movestate_timeout

func next_wander_position():
	var x = rand_range(-wander_range,wander_range)
	var y = rand_range(-wander_range,wander_range)
	return start_position+Vector2(x,y)

func get_wander_position():
	return target_position

func set_movestate_timeout(time):
	timer.start(time) 
	
func _on_Timer_timeout():
	target_position = next_wander_position()
	emit_signal("movestate_timeout")
