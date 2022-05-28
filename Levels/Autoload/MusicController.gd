extends Node

var musica_menu = load("res://Sounds/Menu.wav")


func _ready():
	pass 

func play_musica_menu():
	$AudioStreamPlayer.stream = musica_menu
	$AudioStreamPlayer.play()

func stop_musica_menu():
	$AudioStreamPlayer.stream = musica_menu
	$AudioStreamPlayer.stop()
