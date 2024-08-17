extends CharacterBody2D

const movimentSpeed = 5

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("Jump", "WalkDown")
	if direction != 0:
		velocity.y=movimentSpeed*direction
	else:
		velocity.y=0
		
	move_and_collide(velocity)
