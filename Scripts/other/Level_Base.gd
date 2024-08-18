
class_name LevelBase extends Node2D
@export var grow_text : RichTextLabel
@export var gameover_text : RichTextLabel
@export var win_text : RichTextLabel
static var can_grow = false


func _ready():
	EventBus.on_player_grow.connect(TurnOffUI)
	EventBus.on_player_take_damage.connect(HandleTakeDamage)
	EventBus.on_enemy_take_damage.connect(HandleTakeDamage)


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
	win_text.visible = true
