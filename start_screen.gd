extends Control

func _on_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")  # Replace with your main scene path

func _on_quit_pressed():
	get_tree().quit()
