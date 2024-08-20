class_name GameBar extends ProgressBar

signal BarFull
signal BarEmpty

@export var maxHP = 100
@export var canBeChanged = true # On level start, boss will have this set to false
@export var isHealedOnHit = false # Power up bar will have this set to true
#@export var parentObject := CharacterBody2D  # This did not work

func _ready():
	max_value = maxHP
	if isHealedOnHit:
		value = 1 
	else:
		value = max_value
	
func _on_damage_received(amount : int):
	if canBeChanged:
		if isHealedOnHit:
			if value != max_value:
				# Restore progressBar by "amount"
				var result = value + amount
				if result >= max_value:
					value = max_value
					BarFull.emit()
				else:
					value = result
			 
		else:
			if value != 0:
				# Reduce progressBar by "amount"
				var result = value - amount
				if result <= 0:
					value = 0
					BarEmpty.emit()
				else:
					value = result

