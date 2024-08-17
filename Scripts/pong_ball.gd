extends CharacterBody2D

var _directions=[-1,1]
@onready var Scoreboard = $"../Scoreboard"

const speed=5

func _physics_process(delta: float) -> void:
	for i in range(get_slide_collision_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider.name == "ViewportLimitRight":
			Scoreboard.playerScore+=1
			_directions[0]=-1
		elif collider.name == "ViewportLimitLeft":
			Scoreboard.botScore+=1
			_directions[0]=1
		elif collider.name == "ViewportLimitDown":
			_directions[1]=-1
		elif collider.name == "ViewportLimitUp":
			_directions[1]=1
		elif collider.name == "Player":
			_directions[0]=1
		elif collider.name == "Bot":
			_directions[0]=-1
	
	position.x+=speed*_directions[0]
	position.y+=speed*_directions[1]
	move_and_slide()
	#velocity.x=speed*_directions[0]
	#velocity.y=speed*_directions[1]
	#move_and_slide()
