extends Node2D

var DisplayValue = 0

onready var timer = get_node("Timer")


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	DisplayValue += 1
	pass # Replace with function body.
