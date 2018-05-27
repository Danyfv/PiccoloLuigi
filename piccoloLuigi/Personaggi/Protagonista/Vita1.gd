extends CanvasLayer




func _on_TextureProgress_value_changed(value):
	$MarginContainer/MarginContainer/HBoxContainer/TextureProgress.value = value


func _on_TextureButton_button_down():
		get_tree().change_scene("res://piccoloLuigi/Livelli/Menu1.tscn")
