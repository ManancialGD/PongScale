extends Node

@onready var player: CharacterBody2D = $".."

@onready var cayote_time: Timer = $"../CayoteTime"

const max_speed = 250.0
const JUMP_VELOCITY = -300.0

var has_cayote_time

var is_cayote_time_on

var jumped = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):

	handle_jump(delta)
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("WalkLeft", "WalkRight")
	
	if direction != 0:
		if player.is_on_floor():
			player.velocity.x += direction * (max_speed * 3) * delta
			if abs(player.velocity.x) >= max_speed: player.velocity.x = max_speed * direction
		else:
			player.velocity.x += direction * (max_speed * 5) * delta
			if abs(player.velocity.x) >= max_speed: player.velocity.x = max_speed * direction
	elif player.is_on_floor():
		player.velocity.x = 0
	elif !player.is_on_floor() and abs(player.velocity.x) > 0.1:
		player.velocity.x -= 100 * delta * player.velocity.normalized().x
		
	player.move_and_slide()

func handle_jump(delta : float):
	if player.is_on_floor():
		player.velocity.y = 0
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
	elif Input.is_action_just_released("Jump") and jumped:
		gravity =  ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5
	
	# Add the gravity.
	if !player.is_on_floor():
		player.velocity.y += gravity * delta
	
	print(gravity)

func _on_cayote_time_timeout() -> void:
	if !player.is_on_floor():
		has_cayote_time = false
	is_cayote_time_on = false
