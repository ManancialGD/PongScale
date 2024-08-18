extends CharacterBody2D

const movimentSpeed = 5
var pause=false

func _physics_process(delta: float) -> void:
	if pause: return
	var direction = Input.get_axis("Jump", "WalkDown")
	if direction != 0:
		velocity.y=movimentSpeed*direction
	else:
		velocity.y=0
		
	move_and_collide(velocity)


func _on_game_manager_pong_pause_game() -> void:
	pause=true
