extends KinematicBody2D

const KNOCKBACK_WEIGHT = 4

onready var stats = $Stats

var knockback_dir := Vector2.ZERO

func _process(delta):
	if knockback_dir != Vector2.ZERO:
		knockback_dir = move_and_slide(knockback_dir)
		knockback_dir = knockback_dir.move_toward(Vector2.ZERO,KNOCKBACK_WEIGHT)
	
func _on_Hurtbox_area_entered(area):
	knockback_dir = area.hit_direction * 100
	stats.health -= area.damage

func _on_Stats_health_depleted():
	queue_free()
