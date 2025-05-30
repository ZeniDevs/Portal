extends CharacterBody2D

var player: Node2D
@onready var area_2d: Area2D = $Area2D
@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
@onready var down: RayCast2D = $down

var speed: int = 70
var dir: int = -1
var detec: bool = false
var canjump : bool = true
var can_hit: bool = true


func _ready() -> void: 
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if $ProgressBar.value > 0:
		if detec and player:
			chase_player(delta)
		else:
			wander(delta)
	elif $ProgressBar.value <= 0:
		var particles = preload("res://Scenes/death.tscn").instantiate()
		particles.global_position = global_position
		get_tree().current_scene.add_child(particles)
		queue_free()


	if $up.is_colliding() and canjump:
		if  $up.get_collider().is_in_group("Player"):
			canjump = false
			deplet()
			$Timer.start()


	move_and_slide()

func chase_player(delta: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * speed
	velocity.y += 600 * delta  # gravity
	
	if can_hit:
		if $left.is_colliding():
			var hit = $left.get_collider()
			if hit and hit.is_in_group("Player"):
				can_hit = false
				hit.deplet()
				$hit.start()

		elif $right.is_colliding():
			var hit = $right.get_collider()
			if hit and hit.is_in_group("Player"):
				can_hit = false
				hit.deplet()
				$hit.start()


func wander(delta: float) -> void:
	# Update ray direction
	down.target_position.x = 10 * dir
	down.force_raycast_update()

	# Flip if wall or edge
	if (dir == -1 and left.is_colliding()) or (dir == 1 and right.is_colliding()) or !down.is_colliding():
		dir *= -1

	velocity.x = dir * speed
	velocity.y += 600 * delta  # gravity

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		detec = true

func _on_exit_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		detec = false
		
func deplet():
	$ProgressBar.value -= Dmg.dmg


func _on_timer_timeout() -> void:
	canjump = true


func _on_hit_timeout() -> void:
	can_hit = true
