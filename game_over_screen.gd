extends Control

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://start_screen.tscn")  # Update if needed
