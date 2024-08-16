extends Node

@onready var player: CharacterBody2D = $".."

func _physics_process(_delta: float) -> void:
	for i in range(player.get_slide_collision_count()):
		var collision = player.get_slide_collision(i)
		var collider = collision.get_collider()
		if player.velocity.y < .1 and player.is_on_ceiling():
			if collider is BreakableBlock:
				var block = collider as BreakableBlock
				block.Destroy()
			elif collider is LuckBlock:
				var block = collider as LuckBlock
				block.Interact()
		
