extends CharacterBody2D

class_name Mauro

signal got_damaged()

@onready var stunned_time: Timer = $StunnedTime

func Damage(knockback: Vector2) -> void:
	velocity = knockback
	move_and_slide()
	emit_signal("got_damaged")
	
	stunned_time.start()
