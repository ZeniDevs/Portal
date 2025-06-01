extends Panel

@onready var hpc: Label = $healt/Label
@onready var dmc: Label = $dmg2/Label


func _on_health_pressed() -> void:
	if Coins.coins >= 2 and Coins.tim < 3:
		Coins.coins -= 2
		Coins.tim += 1
		Coins.hp += 3.3
		$"../Label/health".max_value = Coins.hp
		$"../Label/health".value = Coins.hp
	
func _on_dmg_pressed() -> void:
	if Coins.coins >= 2 and Coins.tim1 < 3:
		Coins.tim1 += 1
		Coins.coins -= 2
		Dmg.dmg += 2


func _on_speed_pressed() -> void:
	if Coins.coins >= 2 and Coins.tim2 < 3:
		Coins.tim2 += 1
		Coins.coins -= 2
		Coins.spd += 30

func _physics_process(delta: float) -> void:
	if hpc and dmc:
		hpc.text = str(Coins.tim) + "/3"
		dmc.text = str(Coins.tim1) + "/3"
		$sped/Label.text = str(Coins.tim2) + "/3"
