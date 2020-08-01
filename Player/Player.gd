extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 10
const FRICTION = 10
const ROLL_FACTOR = 1.5

enum {
	MOVE,ATTACK,ROLL
}

var velocity := Vector2.ZERO
var roll_dir := Vector2.LEFT
onready var animationTree = $AnimationTree
onready var animationState = $AnimationTree.get("parameters/playback")

var state = MOVE

func _ready():
	animationTree.active = true

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
		velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		velocity = (velocity + roll_dir * MAX_SPEED * ROLL_FACTOR)/2
	

func attack_state(_delta):
	animationState.travel("Attack")
	
func roll_state(_delta):
	animationState.travel("Roll")
	move()

func move():
	velocity = move_and_slide(velocity)
	
func end_attack_state():
	state = MOVE
	
func end_roll_state():
	state = MOVE
