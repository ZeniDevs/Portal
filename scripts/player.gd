extends CharacterBody2D

@onready var anime: AnimatedSprite2D = $AnimatedSprite2D
var SPEED = Coins.spd
var JUMP_VELOCITY = -250.0
var GRAVITY = 600.0
@export var can_move :bool = true
var ccjump: int = -1
@export var can_shoot: bool = true
var bullet = preload("res://Scenes/bullet.tscn")
@onready var health: TextureProgressBar = $CanvasLayer/Label/health
@onready var regen: Timer = $regen

func _ready() -> void: 
	$CollisionShape2D.disabled = false
	health.max_value = Coins.hp
	health.value = Coins.hp  # Or Coins.current_hp if you're tracking it separately


func _physics_process(delta: float) -> void:
	$CanvasLayer/coincounter.text = str(Coins.coins)
	if health.value <= 0:
		$CollisionShape2D.disabled = true
	else:
		if can_move:
			move()
		if health.value < Coins.hp:
			$regen.start()
		elif health.value == Coins.hp:
			$regen.stop()

	if Input.is_action_just_pressed("he"):
		Coins.coins = 100

	if Input.is_action_just_pressed("shop"):
		if $CanvasLayer/Panel.visible == true:
			$CanvasLayer/Panel.visible = false
		else:
			$CanvasLayer/Panel.visible = true

	SPEED = Coins.spd

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

	if Input.is_action_just_pressed("double") and $CanvasLayer/ProgressBar.value == 10:
		ddshoot()
		$CanvasLayer/ProgressBar.value = 0

	# Apply movement
	move_and_slide()

func shoot():
	
	can_shoot = true
	anime.play("shoot")
	$AudioStreamPlayer2D.play()
	var bullet_ins = bullet.instantiate()

	# Offset for bullet spawn (in front of player and slightly above)
	
	var offset = Vector2(19, -16)  # 20 to the side, 10 up
	offset.x *= -1 if anime.flip_h else 1
	bullet_ins.position = global_position + offset

	# Set bullet direction
	bullet_ins.direction = Vector2.LEFT if anime.flip_h else Vector2.RIGHT

	get_parent().add_child(bullet_ins)

	await anime.animation_finished

	can_shoot = false

func ddshoot():
	anime.play("shoot")
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D.play()
	var bullet_ins = bullet.instantiate()
	var bulleyt_ins2 = bullet.instantiate()
	
	# Offset for bullet spawn (in front of player and slightly above)
	var offset = Vector2(19, -16) 
	offset.x *= -1 if anime.flip_h else 1
	bullet_ins.position = global_position + offset
	
	var offset2 = Vector2(31, -26)  
	offset2.x *= -1 if anime.flip_h else 1
	bulleyt_ins2.position = global_position + offset2
	
	
	# Set bullet direction
	bullet_ins.direction = Vector2.LEFT if anime.flip_h else Vector2.RIGHT
	bulleyt_ins2.direction = Vector2.LEFT if anime.flip_h else Vector2.RIGHT
	
	
	get_parent().add_child(bullet_ins)
	get_parent().add_child(bulleyt_ins2)
	
	await anime.animation_finished
	$CanvasLayer/ProgressBar/AnimationPlayer.play("new_animation")

func deplet():
	health.value -= randi_range(1 , 3)

func _on_regen_timeout() -> void:
	health.value += randi_range(1 , 3)

func jum():
	velocity.y += 120
