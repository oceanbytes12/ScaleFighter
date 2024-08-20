class_name EnemyTitleAnimator extends Node2D

@export var wordAnimTime = 1.5
@export var countdownAnimTime = .7
#@export var announcerVoice := PackedScene
const announcer_SCENE = "res://Scenes/Other/AnnouncerVoice.tscn"

# Plays enemy title animation

func DisplayEnemyTitle(enemy_name):
	match enemy_name:
		"Squirrel":
			TitleSquirrel()
		"Kong":
			TitleKong()
		"Godzilla":
			print("Godzilla Title not implemented yet!")
			#TitleGodzilla()


func TitleSquirrel():
	$Squirrel.show()
	await get_tree().create_timer(wordAnimTime).timeout
	$Squirrel.hide() 
	
	$SquirrelKanji.show()
	await get_tree().create_timer(wordAnimTime).timeout
	$SquirrelKanji.hide()
	TitleCountdown()


func TitleKong():
	$Kong.show()
	await get_tree().create_timer(wordAnimTime).timeout
	$Kong.hide() 
	
	$KongKanji.show()
	await get_tree().create_timer(wordAnimTime).timeout
	$KongKanji.hide() 
	
	TitleCountdown()
	
	
func TitleGodzilla():
	$Godzilla.show()
	await get_tree().create_timer(wordAnimTime).timeout
	$Godzilla.hide() 
	
	$GodzillaKanji.show()
	await get_tree().create_timer(wordAnimTime).timeout
	$GodzillaKanji.hide() 
	
	TitleCountdown()
	

func TitleCountdown():
	$Announcer1.play()
	#var packed_scene = preload(announcer_SCENE)
	#var announcer_node = packed_scene.instantiate()
	##var new_scene = preload("res://Scenes/Other/AnnouncerVoice.tscn")
	##var instance = new_scene.instance()
	##get_parent().get_parent().add_child(announcer_node)
	#get_parent().get_parent().add_child(announcer_node)
		
	$Three.show()
	await get_tree().create_timer(countdownAnimTime).timeout
	$Three.hide() 
	$Two.show()
	await get_tree().create_timer(countdownAnimTime).timeout
	$Two.hide() 
	
	$One.show()
	await get_tree().create_timer(countdownAnimTime).timeout
	$One.hide() 
	
	$Fight.show()
	await get_tree().create_timer(wordAnimTime).timeout
	$Fight.hide() 

# Not in use. Leaving in case needed
func _on_timer_timeout():
	pass # Replace with function body.
