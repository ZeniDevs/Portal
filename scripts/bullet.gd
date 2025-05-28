extends Area2D

@export var speed = 300
var direction = Vector2.RIGHT
@onready var animat: AnimatedSprite2D = $AnimatedSprite2D
var flip:bool

func _process(delta):
	if flip:
		animat.flip_h = false
	else:
		animat.flip_h = true
	position += direction * speed * delta
