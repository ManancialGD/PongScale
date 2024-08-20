extends CharacterBody2D

class_name RPG_Player

# Define movement speed
@export var speed: float = 125.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_area: Area2D = $AttackArea
@onready var swoosh_sprite: AnimatedSprite2D = $AttackArea/SwooshSprite
@onready var attack_cooldown_timer: Timer = $AttackCooldown
@onready var attack_after_time: Timer = $AttackAfterTime
@onready var stun_timer: Timer = $StunTimer

var hp = 5
var is_attacking = false
var on_attacking_cooldown = false

var on_cutscene = false

var stunned = false
var on_start_time = true

var is_dead = false

# Variable to store the last input direction
var previous_input_direction: Vector2 = Vector2.DOWN

func _physics_process(_delta: float) -> void:
	if on_cutscene: return
	if on_start_time: return
	if stunned:
		HandleFriction()
		return
	if is_attacking:
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
		return


	
	# Get input direction from player
	var input_direction = Vector2.ZERO

	if Input.is_action_pressed("WalkRight") and Input.is_action_pressed("WalkLeft"):
		input_direction.x = 0
	elif Input.is_action_pressed("WalkRight"):
		input_direction.x = 1
	elif Input.is_action_pressed("WalkLeft"):
		input_direction.x = -1
	else:
		input_direction.x = 0
		
	
	if Input.is_action_pressed("WalkDown") and Input.is_action_pressed("WalkUp"):
		input_direction.y = 0
	elif Input.is_action_pressed("WalkDown"):
		input_direction.y = 1
	elif Input.is_action_pressed("WalkUp"):
		input_direction.y = -1
	else: input_direction.y = 0
	
	if Input.is_action_just_pressed("Attack") and !on_attacking_cooldown:
		attack_timer.start()
		is_attacking = true
		
		var mouse_position: Vector2 = get_global_mouse_position()

		# Calculate the direction vector from the parent node to the mouse
		var direction: Vector2 = mouse_position - position

		sprite.flip_h = direction.x < 0
		
		if direction.y < 0: sprite.play("AttackUp")
		else: sprite.play("AttackDown")
		# Calculate the angle between the direction vector and the x-axis
		var angle: float = direction.angle()
		
		attack_after_time.start()
		# Rotate the child node to face the mouse
		attack_area.rotation = angle
		
		velocity = direction.normalized() * 150
		move_and_slide()
		return
		
	HandleAnimation(input_direction)
	
	# Move the player character
	velocity = input_direction.normalized() * speed
	
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

func HandleAnimation(input_direction: Vector2) -> void:
	if input_direction.x != 0 or input_direction.y != 0:
		if input_direction.y < 0:
			sprite.play("RunUp")
		else: sprite.play("RunDown")
		if input_direction.x != 0:
			sprite.flip_h = input_direction.x < 0
	else:
		if input_direction.y == 0:
			if previous_input_direction.y < 0: sprite.play("IdleUp")
			elif  previous_input_direction.y > 0: sprite.play("IdleDown")
		if input_direction.x == 0 and previous_input_direction.x != 0:
			sprite.play("IdleDown")

	previous_input_direction = input_direction

func Damage(knockback: Vector2) -> void:
	if stunned: return
	hp -= 1
	if hp <= 0:
		die()
		return
	velocity = knockback
	move_and_slide()
	stunned = true
	stun_timer.start()

func die() -> void:
	sprite.play("Die")
	is_dead = true

func _on_attack_timer_timeout() -> void:
	is_attacking = false
	attack_area.monitoring = false
	
	attack_cooldown_timer.start()
	on_attacking_cooldown = true


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is RPG_Enemy:
		var enemy: RPG_Enemy = body as RPG_Enemy
		var knockback_dir: Vector2 = position - enemy.position
		enemy.Damage(knockback_dir.normalized() * 150 * -1)
	if body is Slime_Boss:
		var boss = body as Slime_Boss
		boss.Damage()

func _on_attack_cooldown_timeout() -> void:
	on_attacking_cooldown = false


func _on_attack_after_time_timeout() -> void:
	attack_area.monitoring = true
	swoosh_sprite.play("default")


func _on_boss_room_entrance_player_entered_room(_player: RPG_Player) -> void:
	hp = 5
	on_cutscene = true


func _on_cutscene_end_timer_timeout() -> void:
	on_cutscene = false


func _on_stun_timer_timeout() -> void:
	stunned = false


func _on_start_fall_timer_timeout() -> void:
	on_start_time = false
