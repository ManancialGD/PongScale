extends Node

@onready var player: CharacterBody2D = $".."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var player_animation: Node = $"../PlayerAnimation"
@onready var land_animation_timer: Timer = $"../LandAnimationTimer"

func _physics_process(_delta: float) -> void:
	for i in range(player.get_slide_collision_count()):
		var collision = player.get_slide_collision(i)
		var collider = collision.get_collider()
		if player.velocity.y < .1 and player.is_on_ceiling():
			if collider is BreakableBlock:
				var block = collider as BreakableBlock
				animated_sprite_2d.play("Land")
				player_animation.can_change_animation = false
				land_animation_timer.start()
				block.Destroy()
			elif collider is LuckBlock:
				var block = collider as LuckBlock
				animated_sprite_2d.play("Land")
				player_animation.can_change_animation = false
				land_animation_timer.start()
				block.Interact()
		
