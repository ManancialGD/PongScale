extends Node

const howManyToPausePong=2
@onready var Ball: CharacterBody2D = $"../Camera2D/Ball"
var pongPaused=false
signal pongPauseGame
@onready var transition_sound: AudioStreamPlayer2D = $TransitionSound

func _process(delta: float) -> void:
	if Ball.playerColCount >= howManyToPausePong && !pongPaused:
		emit_signal("pongPauseGame")
		transition_sound.play()
		pongPaused=true
