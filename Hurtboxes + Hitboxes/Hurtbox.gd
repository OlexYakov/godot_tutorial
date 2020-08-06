extends Area2D

var DefaultHitEffect = preload("res://Effects/HitEffect.tscn")
onready var iframeTimer = $Timer

export(bool) var hitEffectEnabled = true
enum effects {DEFAULT}
export(effects) var effect = effects.DEFAULT
export(Vector2) var effectOffset = Vector2.ZERO
export(float) var iframeTime = -1

var invincible = false

var getResource = {
	effects.DEFAULT : DefaultHitEffect
}

func create_hurt_effect():
	var e = getResource[effect].instance()
	e.global_position = global_position+effectOffset
	get_tree().current_scene.add_child(e)

func _on_Hurtbox_area_entered(area):
	if invincible : return
	PlayerStats.health -= area.damage
	if hitEffectEnabled:
		create_hurt_effect()
	if iframeTime > 0 :
		invincible = true
		set_deferred("monitoring",false)
		iframeTimer.start(iframeTime)
		
func _on_IFrameTimer_timeout():
	monitoring = true
	invincible = false
