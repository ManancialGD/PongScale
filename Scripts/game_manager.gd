extends Node

const howManyToPausePong=3
@onready var Ball: CharacterBody2D = $"../Camera2D/Ball"
var pongPaused=false
signal pongPauseGame

func _process(delta: float) -> void:
	if Ball.playerColCount >= howManyToPausePong && !pongPaused:
		emit_signal("pongPauseGame")
		pongPaused=true
