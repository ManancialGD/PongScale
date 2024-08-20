extends Area2D
@onready var end_after_time: Timer = $EndAfterTime

func _on_body_entered(body: Node2D) -> void:
	if body is Mauro:
		var mauro = body as Mauro
		# Use call_deferred to defer the state change
		call_deferred("_defer_disable_collisions", mauro)

func _defer_disable_collisions(mauro: Mauro) -> void:
	for i in range(mauro.get_child_count()):
		var child = mauro.get_child(i)
		if child is CollisionShape2D:
			var coll = child as CollisionShape2D
			coll.disabled = true
			end_after_time.start()
			break


func _on_end_after_time_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/rpg.tscn")
