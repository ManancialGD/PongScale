extends Node2D

@onready var mario_player: CharacterBody2D =%MarioPlayer

var target: CharacterBody2D

func _ready():
	if mario_player:
		target = mario_player

func _physics_process(delta: float) -> void:
	if target:
		position = lerp(position, target.position, 5 * delta)
