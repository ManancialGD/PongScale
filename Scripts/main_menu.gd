extends Control

@onready var Wall: AudioStreamPlayer = $Wall
@onready var aboutContainer: VBoxContainer = $AboutContainer

func buttonSound():
	Wall.play()

func _on_start_btn_button_down() -> void:
	buttonSound()
	get_tree().change_scene_to_file("res://Scenes/pong.tscn")

func _on_exit_btn_button_down() -> void:
	buttonSound()
	get_tree().quit(0)

func _on_about_btn_button_down() -> void:
	buttonSound()
	aboutContainer.visible = !aboutContainer.visible
