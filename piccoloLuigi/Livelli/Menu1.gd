extends MarginContainer



func _on_Start_button_down():
	get_tree().change_scene("res://piccoloLuigi/Livelli/ProvaLiv.tscn")


func _on_Exit_button_down():
	get_tree().quit()
	
