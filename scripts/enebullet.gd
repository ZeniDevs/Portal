extends Area2D

@export var speed = 250
var direction = Vector2.ZERO
@export var rotation_speed = 720.0  # Degrees per second (adjust to taste)

func _process(delta):
	position += direction * speed * delta
	rotate(deg_to_rad(rotation_speed * delta))  # Rotates the whole Area2D node
	$AnimatedSprite2D.flip_h = direction.x < 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.deplet()
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
