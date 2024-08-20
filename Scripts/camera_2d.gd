extends Camera2D

class_name RPG_Camera

@onready var cutscene: AnimationPlayer = $"../Cutscene"

# Declare variables for camera shake
var original_position : Vector2
var is_shaking : bool = false

# Parameters for shake effect
var shake_frequency : float = 1.0
var shake_amplitude : float = 10.0

# Timer for controlling shake duration
@onready var shaker_timer: Timer = $"../ShakerTimer"

func _ready() -> void:
	# Store the original position of the camera
	original_position = position


func _physics_process(delta: float) -> void:
	if is_shaking:
		# Calculate random offsets for x and y directions
		var random_x = (randf_range(-1.0, 1.0) * 2.0 - 1.0) * shake_amplitude
		var random_y = (randf_range(-1.0, 1.0) * 2.0 - 1.0) * shake_amplitude

		# Apply the calculated shake to the camera's position
		position = original_position + Vector2(random_x, random_y)

func shake(frequency: float, amplitude: float) -> void:
	if not is_shaking:
		shake_frequency = frequency
		shake_amplitude = amplitude
		shaker_timer.start()
		is_shaking = true

func _stop_shake() -> void:
	is_shaking = false
	position = original_position

func _on_shaker_timer_timeout() -> void:
	_stop_shake()

func _on_boss_room_entrance_player_entered_room(_player: RPG_Player) -> void:
	cutscene.play("Cutscene")
