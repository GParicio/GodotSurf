extends Node


var musica_menu = load("res://Sounds/Menu.wav")

func _ready():
	pass # Replace with function body.

func play_music():
	$Music.stream = musica_menu
	$Music.play()
