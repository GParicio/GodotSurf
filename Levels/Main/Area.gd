extends Area


func _on_Muerte_body_entered(body):
	get_tree().reload_current_scene()
