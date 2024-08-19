extends Node

const howManyToPausePong=2
@onready var Ball: CharacterBody2D = $"../Camera2D/Ball"
@onready var transition_sound: AudioStreamPlayer2D = $"../Camera2D/TransitionSound"
@onready var Camera: Camera2D = $"../Camera2D"
@onready var Player: CharacterBody2D = $"../Camera2D/Player"

var pongPaused=false
var transitionSpeed=0
var transitionAcc=0.07
var playerTurnTransition=-1
var playerFallSide=1
signal pongPauseGame

func _process(_delta: float) -> void:
	if Ball.playerColCount >= howManyToPausePong && !pongPaused:
		emit_signal("pongPauseGame")
		transition_sound.play()
		pongPaused=true
		if Ball.position.y+Ball.get_child(0).get_child(0).scale.y*Ball.get_child(0).scale.y/2 > Player.position.y+Player.get_child(0).get_child(0).scale.y/2:
			playerTurnTransition=1
		if Ball.position.x < Player.position.x:
			playerFallSide=-1
	elif pongPaused:
		## TRANSITION FROM PONG TO MAURO
		transitionSpeed+=transitionAcc
		Player.position.x-=transitionSpeed*playerFallSide
		Player.position.y+=transitionSpeed/2
		if Camera.zoom.x > 0.5 && Camera.zoom.y > 0.5: 
			Camera.zoom.x-=transitionAcc/10
			Camera.zoom.y-=transitionAcc/10
		else:
			Camera.offset.x-=transitionSpeed
			if Camera.offset.x <-2000:
				get_tree().change_scene_to_file("res://Scenes/mauro_game.tscn")
		Player.rotate(playerTurnTransition*PI/180/2)
