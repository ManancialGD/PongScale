extends Node

@onready var player: CharacterBody2D = $".."

@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var land_animation_timer: Timer = $"../LandAnimationTimer"
@onready var player_movement: Node = $"../PlayerMovement"

var can_change_animation = true

func _physics_process(_delta: float) -> void:
	if player.is_dead: return
	if !can_change_animation: return
	
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

	if player_movement.jumped and player.is_on_floor():
		animated_sprite_2d.play("Land")
		can_change_animation = false
		land_animation_timer.start()
		
func _on_land_animation_timer_timeout() -> void:
	can_change_animation = true
