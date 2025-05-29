extends Area2D

@export var speed = 250
var direction = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.deplet()
		queue_free()
