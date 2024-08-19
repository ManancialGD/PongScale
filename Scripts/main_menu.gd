extends Control

func _on_start_btn_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/pong.tscn")


func _on_exit_btn_button_down() -> void:
	get_tree().quit(0)
