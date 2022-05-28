extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

var cont = 0

func _ready():
	if(cont == 0):
		MusicController.play_musica_menu()
		cont=1
		
#	if(!MusicController.play_musica_menu()):
#		MusicController.play_musica_menu()
	if (get_tree().current_scene.name == "Inicio"):
		MusicController.play_musica_menu()


func _on_TextureButton3_pressed():
	get_tree().quit()


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Levels/Main/L_Main.tscn")


func _on_Options_pressed():
	get_tree().change_scene("res://Options menu.tscn")


func _on_LinkGithub_pressed():
	OS.shell_open("https://github.com/GParicio/GodotSurf")

