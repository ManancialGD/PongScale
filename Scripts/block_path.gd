extends StaticBody2D


func _on_boss_room_entrance_player_entered_room(_player: RPG_Player) -> void:
	queue_free()
