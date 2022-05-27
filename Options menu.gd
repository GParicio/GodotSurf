extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_pressed():
	get_tree().change_scene("res://Levels/Inicio.tscn")






func _on_CheckBox_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

