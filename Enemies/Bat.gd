extends KinematicBody2D


export var ACCELERATION = 2
export var MAX_VELOCITY = 10
export var FRICTION = 5
export var KNOCKBACK_WEIGHT = 4

export(int) var repulsion_strength = 100

enum states {
	IDLE, WANDER, CHASE
}

onready var stats = $Stats
onready var playerDetector = $PlayerDetectionArea
onready var sprite = $AnimatedSprite
onready var softColisionArea = $SoftColisionArea
onready var movementController = $MovementController
onready var hurtSoundPlayer = $HurtSoundPlayer

var state = states.IDLE setget set_state
var knockback_dir := Vector2.ZERO
var velocity = Vector2.ZERO
var DeathEffect = preload("res://Effects/DeathEffect.tscn")

func _ready():
	movementController.connect("movestate_timeout",self,"random_idle_wander_state_switch")

func _process(delta):
	match state:
		states.IDLE:
			if playerDetector.player_in_range():
				set_state(states.CHASE)
			else:
				velocity = velocity.move_toward(Vector2.ZERO,FRICTION)
		states.WANDER:
			if playerDetector.player_in_range():
				set_state(states.CHASE)
			else:
				var wander_pos = movementController.get_wander_position()
				var dir = global_position.direction_to(wander_pos)
				velocity = velocity.move_toward(dir*MAX_VELOCITY/2,ACCELERATION)
				
				if global_position.distance_to(wander_pos) < velocity.length()*delta:
					set_state(states.IDLE)
		states.CHASE:
			if playerDetector.player_in_range():
				var player = playerDetector.player
				var dir = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(dir*MAX_VELOCITY,ACCELERATION)
			else:
				set_state(states.WANDER)
			sprite.flip_h = velocity.x < 0
	
	if softColisionArea.is_coliding():
		velocity += softColisionArea.get_softcolision_vect() * delta * repulsion_strength
	
	velocity = move_and_slide(velocity)
	
	if knockback_dir != Vector2.ZERO:
		velocity = Vector2.ZERO
		knockback_dir = move_and_slide(knockback_dir)
		knockback_dir = knockback_dir.move_toward(Vector2.ZERO,KNOCKBACK_WEIGHT)

func set_state(value):
	state = value
	match state:
		states.CHASE:
			pass
		states.WANDER:
			movementController.set_movestate_timeout(rand_range(1,6))
		states.IDLE:
			movementController.set_movestate_timeout(rand_range(1,1))
		
func random_idle_wander_state_switch():
	if state == states.CHASE : return
	set_state(chose_random_state([states.IDLE,states.WANDER]))

func chose_random_state(state_list : Array):
	var i = randi()%state_list.size()
	return state_list[i]
	
func _on_Hurtbox_area_entered(area):
	knockback_dir = area.hit_direction * 100
	stats.health -= area.damage
	hurtSoundPlayer.play()
	
signal died

func _on_Stats_health_depleted():
	emit_signal("died")
	var deathEffect = DeathEffect.instance()
	deathEffect.position = position
	deathEffect.offset += Vector2(0,-20)
	get_parent().add_child(deathEffect)
	var deathSoundPlayer = AudioStreamPlayer.new()
	var deathSoundWav = load("res://Music and Sounds/EnemyDie.wav")
	deathSoundPlayer.stream = deathSoundWav
	get_tree().current_scene.add_child(deathSoundPlayer)
	deathSoundPlayer.play()
	
	queue_free()
