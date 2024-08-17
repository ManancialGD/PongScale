extends CharacterBody2D

var _directions=[-1,1]
const speed=180

func _physics_process(delta: float) -> void:
	for i in range(get_slide_collision_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider.name == "ViewportLimitRight":
			_directions[0]=-1
		elif collider.name == "ViewportLimitLeft":
			_directions[0]=1
		elif collider.name == "ViewportLimitDown":
			_directions[1]=-1
		elif collider.name == "ViewportLimitUp":
			_directions[1]=1
			
	velocity.x=speed*_directions[0]
	velocity.y=speed*_directions[1]
	move_and_slide()
