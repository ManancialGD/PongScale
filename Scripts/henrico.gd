extends CharacterBody2D

class_name Henrico

const SPEED = 1400

var direction = -1

var dead = false

var canMove = false
@onready var right_ray_cast: RayCast2D = $RightRayCast
@onready var left_ray_cast: RayCast2D = $LeftRayCast

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var move_after: Timer = $MoveAfter
@onready var delete_timer: Timer = $DeleteTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	move_after.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
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
	if body is Mario:
		var player = body as Mario
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
	animated_sprite.play("Die")
	delete_timer.start()

func PlatformDamage() -> void:
	if dead: return
	dead = true
	animated_sprite.flip_v = true
	animated_sprite.play("PlatformDie")
	velocity.y = -250
	move_and_slide()
	
	delete_timer.start()
	
	collision_shape_2d.disabled = true
	
	z_index = 25
	
	
func _on_move_after_timeout() -> void:
	canMove = true

func _on_delete_timer_timeout() -> void:
	queue_free()
