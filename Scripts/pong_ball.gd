extends CharacterBody2D

var _directions=[-1,1]
var pause=false
@onready var Scoreboard = $"../Scoreboard"
@onready var wall_sound: AudioStreamPlayer2D = $WallSound
@onready var paddle_sound: AudioStreamPlayer2D = $PaddleSound
@onready var point_sound: AudioStreamPlayer2D = $PointSound

const speed=5
var playerColCount=0

func scaleUp():
	scale.x+=0.3
	scale.y+=0.3

func _physics_process(_delta: float) -> void:
	if pause: return
	if $"..".zoom.x > 1 && $"..".zoom.y > 1:
		$"..".zoom.x-=0.005
		$"..".zoom.y-=0.005
	elif $"..".zoom.x != 1 || $"..".zoom.y != 1:
		$"..".zoom.x=1
		$"..".zoom.y=1
	for i in range(get_slide_collision_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider.name == "ViewportLimitRight":
			Scoreboard.playerScore+=1
			point_sound.play()
			_directions[0]=-1
		elif collider.name == "ViewportLimitLeft":
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
			scaleUp()
			$"..".zoom.x=1.04
			$"..".zoom.y=1.04
		elif collider.name == "Bot":
			_directions[0]=-1
			paddle_sound.play()
			scaleUp()
			$"..".zoom.x=1.04
			$"..".zoom.y=1.04
	
	if _directions[1] == 0 && _directions[0] != 0: _directions[1] = [-1,-1].pick_random()
	
	position.y+=speed*_directions[1]
	position.x+=speed*_directions[0]
	move_and_slide()
	#velocity.x=speed*_directions[0]
	#velocity.y=speed*_directions[1]
	#move_and_slide()


func _on_game_manager_pong_pause_game() -> void:
	pause=true
