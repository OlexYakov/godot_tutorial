extends Area2D

var DefaultHitEffect = preload("res://Effects/HitEffect.tscn")

export(bool) var hitEffectEnabled = true
enum effects {DEFAULT}
export(effects) var effect = effects.DEFAULT
export(Vector2) var effectOffset = Vector2.ZERO

var getResource = {
	effects.DEFAULT : DefaultHitEffect
}

func _on_Hurtbox_area_entered(area):
	if hitEffectEnabled:
		var e = getResource[effect].instance()
		e.global_position = global_position+effectOffset
		get_tree().current_scene.add_child(e)
