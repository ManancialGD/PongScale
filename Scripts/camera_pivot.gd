extends Node2D

@export var target: CharacterBody2D


func _physics_process(delta: float) -> void:
	if target:
		position = lerp(position, target.position, 5 * delta)
