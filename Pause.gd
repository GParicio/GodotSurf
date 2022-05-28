extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(false)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_Button_pressed():
	get_tree().paused = false
	set_visible(false)
	match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible

func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen



func _on_Button2_pressed():
	get_tree().quit()


func _on_Button3_pressed():
	get_tree().change_scene("res://Levels/Inicio.tscn")
	get_tree().paused = false
	set_visible(false)
