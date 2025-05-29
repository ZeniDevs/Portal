extends Node

var mindmg:int = 1
var maxdmg:int = 3
var dmg: int

func _process(delta: float) -> void:
	dmg = randi_range(mindmg , maxdmg) 
