extends CharacterBody2D

const speed = 5
@onready var Ball: CharacterBody2D = $"../Ball"

func _physics_process(delta: float) -> void:
	velocity.y=0
	if Ball.position.x > 50:
		if Ball.position.y > position.y:
			velocity.y=speed
		else:
			velocity.y=-speed
	move_and_collide(velocity)
