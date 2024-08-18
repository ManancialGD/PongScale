extends CharacterBody2D

var _directions=[-1,1]
var pause=false
@onready var Scoreboard = $"../Scoreboard"
@onready var wall_sound: AudioStreamPlayer2D = $WallSound
@onready var paddle_sound: AudioStreamPlayer2D = $PaddleSound
@onready var point_sound: AudioStreamPlayer2D = $PointSound
@onready var ColTimer: Timer = $Collision

const speed=5
var playerColCount=0

func _physics_process(delta: float) -> void:
	if pause: return
	for i in range(get_slide_collision_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider.name == "ViewportLimitRight":
			ColTimer.start()
			$CollisionShape2D.disabled=true
			Scoreboard.playerScore+=1
			point_sound.play()
			_directions[0]=-1
		elif collider.name == "ViewportLimitLeft":
			ColTimer.start()
			$CollisionShape2D.disabled=true
			Scoreboard.botScore+=1
			point_sound.play()
			_directions[0]=1
		elif collider.name == "ViewportLimitDown":
			_directions[1]=-1
			wall_sound.play()
		elif collider.name == "ViewportLimitUp":
			_directions[1]=1
			wall_sound.play()
		elif collider.name == "Player":
			_directions[0]=1
			playerColCount+=1
			paddle_sound.play()
		elif collider.name == "Bot":
			_directions[0]=-1
			paddle_sound.play()
	
	if _directions[1] == 0 && _directions[0] != 0: _directions[1] = [-1,-1].pick_random()
	
	position.y+=speed*_directions[1]
	position.x+=speed*_directions[0]
	move_and_slide()
	#velocity.x=speed*_directions[0]
	#velocity.y=speed*_directions[1]
	#move_and_slide()


func _on_game_manager_pong_pause_game() -> void:
	pause=true


func _on_collision_timeout() -> void:
	$CollisionShape2D.disabled=false
