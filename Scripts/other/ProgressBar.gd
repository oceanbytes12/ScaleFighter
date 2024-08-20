class_name GameBar extends ProgressBar

signal BarFull
signal BarEmpty

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

@export var maxHP = 100
@export var canBeChanged = true # On level start, boss will have this set to false
@export var isHealedOnHit = false # Power up bar will have this set to true
#@export var parentObject := CharacterBody2D  # This did not work

var health = 0 

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health
	
func _set_health(new_health):
	var prev_health = health
	if !isHealedOnHit:
		health = min(max_value, new_health)
	else:
		health = new_health
	value = health
	
	if health < prev_health:
		timer.start()
	else:
		timer.start() # Not sure if belongs here
		damage_bar.value = health

func _ready():
	max_value = maxHP
	
	init_health(maxHP)
	
	if isHealedOnHit:
		value = 1 
		damage_bar.value = 1
	else:
		value = max_value
		damage_bar.value = max_value
	
func _on_damage_received(amount : int):
	if canBeChanged:
		if isHealedOnHit:
			print("old value ", value)
			if value != max_value:
				# Restore progressBar by "amount"
				var result = value + amount
				print("result value ", result)
				print("max value ", max_value)
				if result >= max_value:
					_set_health(max_value)
					#value = max_value
					print("bar full emit")
					BarFull.emit()
				else:
					_set_health(result)
					#value = result
				print("new value ", value)
			 
		else:
			if value != 0:
				# Reduce progressBar by "amount"
				var result = value - amount
				if result <= 0:
					_set_health(0)
					#value = 0
					BarEmpty.emit()
				else:
					_set_health(result)
					#value = result



func _on_timer_timeout():
	damage_bar.value = health
