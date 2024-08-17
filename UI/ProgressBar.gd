extends ProgressBar

signal BarFull
signal BarEmpty

@export var canBeChanged = true # On level start, boss will have this set to false
@export var isHealedOnHit = false # Power up bar will have this set to true
#@export var parentObject := CharacterBody2D  # This did not work


func _ready():
	if isHealedOnHit:
		value = 1 
	else:
		value = max_value
	
	## Connect to "DamageTaken" signal in either Player or Boss this bar is connected to
	#if parentObject != null:
		#parentObject.DamageTaken.connect(_on_damage_received) # Invalid get index in CharacterBody2D

	
func _on_damage_received(amount : int):
	if canBeChanged:
		if isHealedOnHit:
			# Restore progressBar by "amount"
			var result = value + amount
			if result >= max_value:
				value = max_value
				BarFull.emit()
			else:
				value = result
			 
		else:
			# Reduce progressBar by "amount"
			var result = value - amount
			if result <= 0:
				value = 0
				BarEmpty.emit()
			else:
				value = result

