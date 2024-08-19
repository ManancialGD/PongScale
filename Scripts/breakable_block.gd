extends StaticBody2D

class_name BreakableBlock

@onready var particles_timer: Timer = $ParticlesTimer
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var bump_animation: AnimationPlayer = $BumpAnimation
@onready var area_2d: Area2D = $Area2D

func Destroy():
	var bodies = area_2d.get_overlapping_bodies()
	for body in bodies:
		if body is Henrico:
			var character = body as Henrico
			character.velocity.y = -150
			character.move_and_slide()
			character.PlatformDamage()

	particles_timer.start()
	sprite_2d.visible = false
	cpu_particles_2d.emitting = true
	collision_shape_2d.disabled = true
	hit_sound.play()


func _on_particles_timer_timeout() -> void:
	queue_free()
