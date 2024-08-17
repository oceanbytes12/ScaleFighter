
class_name LevelBase extends Node2D
@export var grow_text : RichTextLabel
static var can_grow = false
static var character_scale = 1


func _ready():
	EventBus.on_player_grow.connect(TurnOffUI)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func TurnOffUI():
	grow_text.visible = false
	
func _on_player_hp_bar_empty():
	# Game Over text appears on screen
	pass # Replace with function body.


func _on_grow_bar_full():
	grow_text.visible = true
	can_grow = true
	# Text prompt on screen for player: "Press 'G' to Grow!"
	pass # Replace with function body.


func _on_boss_hp_bar_empty():
	# Level Complete
	pass # Replace with function body.
