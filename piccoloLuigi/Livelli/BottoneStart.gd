extends TouchScreenButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if Input.is_mouse_button_pressed(1):
		get_tree().change_scene("res://piccoloLuigi/Livelli/ProvaLiv.tscn")