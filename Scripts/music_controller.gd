extends Node2D

@onready var _1: AudioStreamPlayer2D = $"1"
@onready var transition: AudioStreamPlayer2D = $Transition
@onready var main: AudioStreamPlayer2D = $Main
@onready var intro: AudioStreamPlayer2D = $Intro

func _on_intro_finished() -> void:
	_1.play()


func _on_boss_room_entrance_player_entered_room(player: RPG_Player) -> void:
	intro.stop()
	_1.stop()
	transition.play()


func _on_transition_finished() -> void:
	main.play()
