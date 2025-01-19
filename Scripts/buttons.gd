extends Button

func _on_PlayButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_CreditButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

func _on_BackButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
