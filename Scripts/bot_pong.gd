extends CharacterBody2D

const acc = 1
const maxSpeed = 5
@onready var Ball: CharacterBody2D = $"../Ball"

func _physics_process(delta: float) -> void:
	if Ball.position.x > 60 && Ball._directions[0] == 1:
		if Ball.position.y > position.y:
			if velocity.y < maxSpeed: velocity.y+=acc
		else:
			if velocity.y > -maxSpeed: velocity.y-=acc
	else:
		velocity.y=0
	move_and_collide(velocity)
