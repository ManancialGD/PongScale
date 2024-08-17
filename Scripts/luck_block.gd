extends StaticBody2D

class_name LuckBlock

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var power_up_out: AudioStreamPlayer2D = $PowerUpOut

@onready var jump_animation: AnimationPlayer = $JumpAnimation
@onready var bump: AudioStreamPlayer2D = $Bump

var instance

var has_been_interacted = false

func _ready():
	# Step 1: Load the scene
	var scene_to_instance = preload("res://Scenes/power_up.tscn")
	
	# Step 2: Instantiate the scene
	instance = scene_to_instance.instantiate()


func Interact():
	if has_been_interacted:
		jump_animation.play("Hit")
		bump.play()
		return
	has_been_interacted = true
	
	instance.position = Vector2(position.x, position.y - 16)
	get_tree().root.add_child(instance)

	animated_sprite_2d.play("done")
	
	power_up_out.play()
	
	jump_animation.play("Hit")
