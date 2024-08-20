extends CharacterBody2D

class_name Slime_Boss
@export var camera: RPG_Camera

@onready var attack_area: Area2D = $AttackArea
@onready var impact_animation: AnimationPlayer = $AttackArea/ImpactAnimation
@onready var damageAnim: AnimationPlayer = $Damage
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var target: CharacterBody2D
@export var speed: float = 150
@onready var impact_timer: Timer = $ImpactTimer

var on_cutscene = true
var before_cutscene = true
var switch_animation = false

var hp = 15
var is_dead = false
@onready var delete_after_timer: Timer = $DeleteAfterTimer

func _process(delta: float) -> void:
	if is_dead: return
	if before_cutscene: return
	if anim.frame == 11:
		impact_animation.play("Impact")
		attack_area.monitoring = true
		impact_timer.start()
		camera.shake(5,5)

func _physics_process(_delta: float) -> void:
	if is_dead: return
	if on_cutscene: return
	if target == null: return
	
	HandleFriction()
	var target_dir: Vector2 = target.position - position
	var target_distance: float = global_position.distance_to(target.global_position)
	
	if anim.frame == 5 and target_distance >= 32:
		velocity = target_dir.normalized() * speed
	
	# Get the current frame
	var current_frame = anim.frame
	
	# Determine which animation to play
	if target_dir.y < 0 and switch_animation:
		anim.play("WalkUp", true)  # Use `true` to ensure the animation restarts
		switch_animation = false
	elif target_dir.y >= 0 and !switch_animation:
		anim.play("WalkDown", true)
		switch_animation = true
	
	# Restore the current frame if the animation was switched
	if anim.is_playing() and anim.frame != current_frame:
		anim.frame = current_frame
	
	anim.flip_h = target_dir.x > 0
	move_and_slide()
		
func HandleFriction():
	if velocity != Vector2.ZERO:
		var current_speed: float = velocity.length()
		if current_speed > 10:
			var friction: float = 10.0
			var reduction: float = friction
			current_speed = max(current_speed - reduction, 0)
			velocity = velocity.normalized() * current_speed
		else:
			velocity = Vector2.ZERO
		
		move_and_slide()
		
func Damage():
	damageAnim.play("Damage")
	hp -= 1
	if hp == 0:
		anim.play("Die")
		die()

func die() -> void:
	delete_after_timer.start()
	
func _on_cutscene_end_timer_timeout() -> void:
	on_cutscene = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is RPG_Player:
		var player = body as RPG_Player
		var player_dir = player.position - position
		player.Damage(player_dir.normalized() * 500)


func _on_impact_timer_timeout() -> void:
	attack_area.monitoring = false


func _on_delete_after_timer_timeout() -> void:
	queue_free()


func _on_boss_room_entrance_player_entered_room(player: RPG_Player) -> void:
	before_cutscene = false
