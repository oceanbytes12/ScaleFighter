extends Sprite2D

# Toggles the visibility of object script is attached to
func toggle_visibility():
	if visible == true:
		hide()
	else:
		show()
	$Timer.start()
