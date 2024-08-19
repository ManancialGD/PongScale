extends CharacterBody2D

class_name Henrico

const SPEED = 1400

var direction = -1

var dead = false

var canMove = false

var normalDeath = false

@onready var right_ray_cast: RayCast2D = $RightRayCast
@onready var left_ray_cast: RayCast2D = $LeftRayCast
@onready var crushed_sound: AudioStreamPlayer2D = $CrushedSound

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var move_after: Timer = $MoveAfter
@onready var delete_timer: Timer = $DeleteTimer
@onready var physics_collider: CollisionShape2D = $PhysicsCollider

var random_direction = [-1, 1].pick_random()

func _ready() -> void:
	move_after.start()
	random_direction = [-1, 1].pick_random()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if normalDeath:
		rotation += random_direction * 2.5 * delta
	
	if !is_on_floor():
		velocity.y -= -980 * delta
	
	if dead:
		move_and_slide()
		return
	if !canMove:
		return
		
	if !right_ray_cast.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
	if !left_ray_cast.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
	if !left_ray_cast.is_colliding() and !right_ray_cast.is_colliding():
		direction = 0
		
	velocity.x = SPEED * direction * delta
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if dead: return
	if body is Mauro:
		var player = body as Mauro
		if player.velocity.y > 0:
			Damage()
			player.velocity.y = -250
			player.move_and_slide()
		else:
			var knockbackDir = 0
			if player.position.x > position.x:
				knockbackDir = 1
			else:
				knockbackDir = -1
			player.Damage(Vector2(knockbackDir, -1).normalized() * 250)
			
			player.move_and_slide()
			

func Damage() -> void:
	if dead: return
	dead = true
	normalDeath = true
	animated_sprite.play("Die")
	crushed_sound.play()
	velocity.y = -125
	
	move_and_slide()
	
	delete_timer.start()
	
	physics_collider.queue_free()
	
	z_index = 25

func PlatformDamage() -> void:
	if dead: return
	dead = true
	animated_sprite.flip_v = true
	animated_sprite.play("PlatformDie")
	velocity.y = -250
	move_and_slide()
	
	delete_timer.start()
	
	physics_collider.disabled = true
	
	z_index = 25
	crushed_sound.play()
	
func _on_move_after_timeout() -> void:
	canMove = true

func _on_delete_timer_timeout() -> void:
	queue_free()
