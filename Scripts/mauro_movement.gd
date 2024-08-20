extends Node

@onready var player: CharacterBody2D = $".."

@onready var cayote_time: Timer = $"../CayoteTime"

const max_speed = 150.0
const JUMP_VELOCITY = -300.0

@onready var jump_sound: AudioStreamPlayer2D = $"../JumpSound"

var has_cayote_time

var is_cayote_time_on

var jumped = false

var damaged = false

var initial_movement_block = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if player.is_dead: return
	handle_jump(delta)
	if damaged:
		player.move_and_slide()
		return
		
	if player.is_on_floor() and initial_movement_block:
		initial_movement_block = false
	if initial_movement_block:
		player.move_and_slide()
		return
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("WalkLeft", "WalkRight")
	
	if direction != 0:
			player.velocity.x += direction * (max_speed * 3) * delta
			if abs(player.velocity.x) >= max_speed: player.velocity.x = max_speed * direction
			player.velocity.x += direction * (max_speed * 5) * delta
			if abs(player.velocity.x) >= max_speed: player.velocity.x = max_speed * direction
	elif player.is_on_floor():
		player.velocity.x = 0
	elif !player.is_on_floor() and abs(player.velocity.x) > 0.1:
		player.velocity.x -= 100 * delta * player.velocity.normalized().x
		
	player.move_and_slide()

func handle_jump(delta : float):
	if player.is_on_floor():
		if !damaged: player.velocity.y = 0
		has_cayote_time = true
	
	if has_cayote_time and !player.is_on_floor() and !is_cayote_time_on:
		cayote_time.start()
		is_cayote_time_on = true
	
	if player.is_on_floor() and jumped:
		gravity =  ProjectSettings.get_setting("physics/2d/default_gravity")
		jumped = false

	if Input.is_action_just_pressed("Jump") and has_cayote_time:
		gravity =  ProjectSettings.get_setting("physics/2d/default_gravity") / 1.5
		player.velocity.y = JUMP_VELOCITY
		has_cayote_time = false
		jumped = true
		jump_sound.pitch_scale = randf_range(0.8, 1.2)
		jump_sound.play()
	elif Input.is_action_just_released("Jump") and jumped:
		gravity =  ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5
	
	# Add the gravity.
	if !player.is_on_floor():
		player.velocity.y += gravity * delta

func _on_cayote_time_timeout() -> void:
	if !player.is_on_floor():
		has_cayote_time = false
	is_cayote_time_on = false


func _on_player_got_damaged() -> void:
	damaged = true
	print("Damaged")


func _on_stunned_time_timeout() -> void:
	damaged = false
