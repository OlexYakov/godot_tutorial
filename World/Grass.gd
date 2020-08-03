extends Node2D

var GrassEffect = preload("res://Effects/GrassDestroyedEffect.tscn")

func _on_Hurtbox_area_entered(_area):
	var grassEffect = GrassEffect.instance()
	grassEffect.position = position
	get_parent().add_child(grassEffect)
	queue_free()
