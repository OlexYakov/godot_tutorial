extends Area2D

var player : KinematicBody2D = null

func player_in_range():
	return player != null

func _on_player_entered(body):
	player = body

func _on_player_exited(body):
	player = null
