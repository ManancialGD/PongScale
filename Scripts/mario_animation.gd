extends Node

@onready var player: CharacterBody2D = $".."

@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"

func _physics_process(_delta: float) -> void:

	if player.velocity.x > 0.1:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("Run")
	elif player.velocity.x < -0.1:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("Run")
	else:
		animated_sprite_2d.play("Idle")
		
	if player.velocity.y < 0:
		animated_sprite_2d.play("Jump")
	elif player.velocity.y > 0:
		animated_sprite_2d.play("Fall")
