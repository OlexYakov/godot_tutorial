extends AnimatedSprite

func _ready():
	play("default")
	connect("animation_finished",self,"_on_animation_finished")

func _on_animation_finished():
	queue_free()
