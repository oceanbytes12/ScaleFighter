
class_name LevelBase extends Node2D
@export var grow_text : RichTextLabel
@export var gameover_text : RichTextLabel
@export var win_text : RichTextLabel

@onready var animator := $CanvasLayer/ColorRect/AnimationPlayer
@export var right_wall_collider : CollisionShape2D

static var can_grow = false


func _ready():
	EventBus.on_player_grow.connect(TurnOffUI)
	EventBus.on_player_take_damage.connect(HandleTakeDamage)
	EventBus.on_enemy_take_damage.connect(HandleTakeDamage)
	if(animator):
		animator.play("FadeIn")
	await get_tree().create_timer(1).timeout
	EventBus.on_game_ready.emit()


func TurnOffUI():
	grow_text.visible = false

func HandleTakeDamage(amount):
	if(amount > 10):
		var duration = 0.4
		var timeScale = 0.1
		Engine.time_scale = timeScale
		await get_tree().create_timer(duration*timeScale).timeout
		Engine.time_scale = 1
	
func _on_player_hp_bar_empty():
	# Game Over text appears on screen
	gameover_text.visible = true
	get_tree().paused = true


func _on_grow_bar_full():
	# Text prompt on screen for player: "Press 'G' to Grow!"	
	grow_text.visible = true
	can_grow = true


func _on_boss_hp_bar_empty():
	# Level Complete
	# Disable right wall
	right_wall_collider.set_deferred("disabled", true)
	# Display new power text	
	win_text.visible = true



func _on_exit_level_trigger_body_entered(body):
	if body is Player:
		# Load next level
		#Show temp text so we know it's not frozen?
		print("Player exited level.")
		#get_tree().paused = true
		load_level()


func load_level():
	# For now, just reload the current level
	get_tree().call_deferred("reload_current_scene")
