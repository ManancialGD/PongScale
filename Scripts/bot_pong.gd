extends CharacterBody2D

func _physics_process(delta: float) -> void:
	velocity.y=randi_range(-1, 1)*randi_range(3, 5)
	move_and_collide(velocity)
