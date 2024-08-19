extends CharacterBody2D

const movimentSpeed = 5
var pause=false
var transitionSpeed=0
var transitionAcc=0.07

@onready var transition_sound: AudioStreamPlayer2D = $TransitionSound

func _physics_process(delta: float) -> void:
	if pause: 
		transitionSpeed+=transitionAcc
		position.x-=transitionSpeed
		position.y+=transitionSpeed/2
		if $"..".zoom.x > 0.5 && $"..".zoom.y > 0.5: 
			$"..".zoom.x-=transitionAcc/10
			$"..".zoom.y-=transitionAcc/10
		rotate(-PI/180/2)
		return
	var direction = Input.get_axis("Jump", "WalkDown")
	if direction != 0:
		velocity.y=movimentSpeed*direction
	else:
		velocity.y=0
		
	move_and_collide(velocity)


func _on_game_manager_pong_pause_game() -> void:
	transition_sound.play()
	$CollisionShape2D.disabled=true
	pause=true
