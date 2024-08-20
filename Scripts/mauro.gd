extends CharacterBody2D

class_name Mauro

signal got_damaged()

@onready var stunned_time: Timer = $StunnedTime
@onready var restart_after_timer: Timer = $RestartAfterTimer

var hp = 3
var is_dead = false

func _physics_process(delta: float) -> void:
	if is_dead:
		HandleFriction()

func Damage(knockback: Vector2) -> void:
	if is_dead: return
	hp -= 1
	if hp <= 0:
		die()
	velocity = knockback
	move_and_slide()
	emit_signal("got_damaged")
	
	stunned_time.start()

func die() -> void:
	restart_after_timer.start()
	is_dead = true

func HandleFriction():
	if velocity != Vector2.ZERO:
		# Calculate the current speed
		var current_speed: float = velocity.length()
		
		# If the speed is greater than a threshold, apply friction
		if current_speed > 10:
			# Reduce the velocity proportionally
			var friction: float = 10.0
			var reduction: float = friction
			
			# Calculate the new velocity
			current_speed = max(current_speed - reduction, 0)
			
			# Normalize the velocity vector and scale it by the new speed
			velocity = velocity.normalized() * current_speed
		else:
			# If speed is below the threshold, stop completely
			velocity = Vector2.ZERO
		
		# Move the player character
		move_and_slide()

func _on_restart_after_timer_timeout() -> void:
	get_tree().reload_current_scene()
