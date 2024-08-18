
class_name LevelBase extends Node2D
@export var grow_text : RichTextLabel
@export var gameover_text : RichTextLabel
@export var win_text : RichTextLabel
static var can_grow = false
static var character_scale = 1


func _ready():
	EventBus.on_player_grow.connect(TurnOffUI)


func TurnOffUI():
	grow_text.visible = false

	
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
