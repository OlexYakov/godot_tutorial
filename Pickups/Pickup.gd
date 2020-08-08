extends Sprite

func apply_effect(_player):
	pass

func _on_player_entered(body):
	apply_effect(body)
	queue_free()
