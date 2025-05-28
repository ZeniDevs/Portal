extends CharacterBody2D

@onready var anime: AnimatedSprite2D = $AnimatedSprite2D
var SPEED = 170.0
var JUMP_VELOCITY = -250.0
var GRAVITY = 600.0  # You can tweak thisO
@export var can_move :bool = true
var ccjump: int = -1
@export var can_shoot: bool = true
var bullet = preload("res://Scenes/bullet.tscn")


func _physics_process(delta: float) -> void:
	if can_move:
		move()

func move():
	# Add gravity
	if not is_on_floor():
		velocity.y += GRAVITY * get_physics_process_delta_time()

	# Handle jump
	if Input.is_action_just_pressed("jump") and ccjump <= 0:
		ccjump += 1
		velocity.y = JUMP_VELOCITY
	if is_on_floor():
		ccjump = 0

	# Handle horizontal input
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		anime.flip_h = direction < 0
		if !can_shoot:
			anime.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if !can_shoot:
			anime.play("idle")

	#handle shoot
	if !can_shoot:
		if Input.is_action_just_pressed("shoot"):
			shoot()

	# Apply movement
	move_and_slide()

func shoot():
	can_shoot = true
	anime.play("shoot")

	var bullet_ins = bullet.instantiate()

	# Offset for bullet spawn (in front of player)
	var offset = Vector2(20, 0)
	offset.x *= -1 if anime.flip_h else 1
	bullet_ins.position = global_position + offset

	# Set bullet direction
	bullet_ins.direction = Vector2.LEFT if anime.flip_h else Vector2.RIGHT

	get_parent().add_child(bullet_ins)

	await anime.animation_finished

	can_shoot = false
