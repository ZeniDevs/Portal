extends Area2D

@export var speed = 300
var direction = Vector2.RIGHT
@onready var animat: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta):
	animat.flip_h = direction.x < 0
	position += direction * speed * delta
