extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("heu")
	$CPUParticles2D.emitting = true


func _process(delta: float) -> void:
	pass
