extends CharacterBody2D

class_name RPG_Enemy

@onready var delete_timer: Timer = $DeleteTimer
@onready var coll: CollisionShape2D = $CollisionShape2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var stun_time: Timer = $StunTime
@onready var attack_area: Area2D = $AttackArea
@onready var attack_timer: Timer = $AttackTimer

var current_hp = 3
var isDead = false
var is_stunned = false
var is_attacking = false
@onready var attack_after_time: Timer = $AttackAfterTime

@onready var target: CharacterBody2D = %RPGPlayer
@export var speed: float = 25

func _physics_process(_delta: float) -> void:
	HandleFriction()
	
	if isDead or is_stunned: return
	
	if target != null and !is_attacking:
		var target_dir: Vector2 = target.position - position
		var target_distance: float = global_position.distance_to(target.global_position)
		
		if target_distance <= 40 and !is_attacking:
			is_attacking = true
			attack_after_time.start()
			if velocity.y < 0: anim.play("AttackUp")
			else: anim.play("AttackDown")
		velocity = target_dir.normalized() * speed
		if !is_attacking:
			if velocity.y < 0:
				anim.play("WalkUp")
			else:
				anim.play("WalkDown")
			anim.flip_h = velocity.x > 0
		move_and_slide()


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

func Damage(knockback: Vector2) -> void:
	if isDead or is_stunned: return
	is_stunned = true
	stun_time.start()
	current_hp -= 1
	if current_hp <= 0:
		die()
	else:
		anim.play("Damage")
	velocity = knockback
	move_and_slide()
	if is_attacking:
		is_attacking = false
		if !attack_after_time.is_stopped(): attack_after_time.stop()
		if !attack_timer.is_stopped(): attack_timer.stop()

func die() -> void:
	isDead = true
	call_deferred("_defer_die")

func _defer_die() -> void:
	coll.disabled = true
	if velocity.y < 0:
		anim.play("DieUp")
	else: anim.play("DieDown")
	delete_timer.start()

func _on_delete_timer_timeout() -> void:
	queue_free()


func _on_stun_time_timeout() -> void:
	is_stunned = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is RPG_Player:
		var player = body as RPG_Player
		var player_dir = player.position - position
		player.Damage(player_dir.normalized() * 150)


func _on_attack_timer_timeout() -> void:
	is_attacking = false
	attack_area.monitoring = false


func _on_attack_after_time_timeout() -> void:
	if is_stunned: return
	attack_area.monitoring = true
	attack_timer.start()
