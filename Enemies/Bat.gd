extends KinematicBody2D


export var ACCELERATION = 2
export var MAX_VELOCITY = 10
export var FRICTION = 5
export var KNOCKBACK_WEIGHT = 4

enum states {
	IDLE, WANDER, CHASE
}

onready var stats = $Stats
onready var playerDetector = $PlayerDetectionArea
onready var sprite = $AnimatedSprite

var state = states.IDLE
var knockback_dir := Vector2.ZERO
var velocity = Vector2.ZERO
var DeathEffect = preload("res://Effects/DeathEffect.tscn")

func _process(delta):
	match state:
		states.IDLE:
			if playerDetector.player_in_range():
				state = states.CHASE
			velocity = velocity.move_toward(Vector2.ZERO,FRICTION)
			velocity = move_and_slide(velocity)
		states.WANDER:
			pass
		states.CHASE:
			if playerDetector.player_in_range():
				var player = playerDetector.player
				var dir = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(dir*MAX_VELOCITY,ACCELERATION)
				velocity = move_and_slide(velocity)
				sprite.flip_h = dir.x < 0
			else:
				state = states.IDLE
			
	if knockback_dir != Vector2.ZERO:
		velocity = Vector2.ZERO
		knockback_dir = move_and_slide(knockback_dir)
		knockback_dir = knockback_dir.move_toward(Vector2.ZERO,KNOCKBACK_WEIGHT)
	
func _on_Hurtbox_area_entered(area):
	knockback_dir = area.hit_direction * 100
	stats.health -= area.damage

func _on_Stats_health_depleted():
	queue_free()
	var deathEffect = DeathEffect.instance()
	deathEffect.position = position
	deathEffect.offset += Vector2(0,-20)
	get_parent().add_child(deathEffect)
