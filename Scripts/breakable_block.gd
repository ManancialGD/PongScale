extends StaticBody2D

class_name BreakableBlock

@onready var particles_timer: Timer = $ParticlesTimer
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var bump_animation: AnimationPlayer = $BumpAnimation

func Destroy():
	particles_timer.start()
	sprite_2d.visible = false
	cpu_particles_2d.emitting = true
	collision_shape_2d.disabled = true
	hit_sound.play()


func _on_particles_timer_timeout() -> void:
	queue_free()
