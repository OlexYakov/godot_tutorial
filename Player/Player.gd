extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 10
const FRICTION = 10
const ROLL_FACTOR = 1.5


enum {
	MOVE,ATTACK,ROLL
}

var velocity := Vector2.ZERO
var roll_dir := Vector2.DOWN
onready var animationTree = $AnimationTree
onready var animationState = $AnimationTree.get("parameters/playback")
onready var IFrameAnimationPlayer = $IFrameAnimation
onready var swordDirection = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var stats = PlayerStats
onready var cameraRemoteTransform = $RemoteTransform2D

export(NodePath) onready var camera_node_path

var state = MOVE

func _ready():
	animationTree.active = true
	swordDirection.hit_direction = Vector2.LEFT
	stats.connect("health_depleted",self,"_on_health_depleted")
	hurtbox.connect("damage_taken",self,"damage_taken_handler")
	hurtbox.connect("invencibility_started",self,"play_flash_animation")
	hurtbox.connect("invencibility_ended",self,"stop_flash_animation")
	cameraRemoteTransform.remote_path = get_node(camera_node_path).get_path()

func _process(_delta):
	match state:
		MOVE:
			move_state(_delta)
		ROLL:
			roll_state(_delta)
		ATTACK:
			attack_state(_delta)
			
func move_state(_delta):
	var dir := Vector2.ZERO
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	dir = dir.normalized()
	
	if dir != Vector2.ZERO:
		velocity = velocity.move_toward(dir*MAX_SPEED,ACCELERATION)
		roll_dir = dir
		swordDirection.hit_direction = dir
#		print(animationTree.get("parameters/Idle/blend_position"))
		animationState.travel("Run")
		animationTree.set("parameters/Roll/blend_position",dir)
		animationTree.set("parameters/Run/blend_position",dir)
		animationTree.set("parameters/Idle/blend_position",dir)
		animationTree.set("parameters/Attack/blend_position",dir)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION)
	
	move()
	
	if Input.is_action_just_pressed("attack") :
		state = ATTACK
		velocity /= 20
	elif Input.is_action_just_pressed("roll"):
		state = ROLL
		velocity = (velocity + roll_dir * MAX_SPEED * ROLL_FACTOR)/2

func attack_state(_delta):
	animationState.travel("Attack")
	move()
	
func end_attack_state():
	state = MOVE
	
func roll_state(_delta):
	hurtbox.invincible = true
	animationState.travel("Roll")
	move()
	
func end_roll_state():
	state = MOVE
	hurtbox.invincible = false

func move():
	velocity = move_and_slide(velocity)
	
func _on_health_depleted():
	queue_free()
	
func damage_taken_handler(damage):
	PlayerStats.health -= damage
	
func play_flash_animation():
	IFrameAnimationPlayer.play("Start")
func stop_flash_animation():
	IFrameAnimationPlayer.play("End")
