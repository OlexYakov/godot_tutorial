extends Node2D

var GrassEffect : PackedScene
var bushes : Node2D

func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		pass

func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_Hurtbox_area_entered(_area):
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("destroy")
	$Sprite.visible = false
