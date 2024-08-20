extends Camera2D

@onready var cutscene: AnimationPlayer = $"../Cutscene"



func _on_boss_room_entrance_player_entered_room(_player: RPG_Player) -> void:
	cutscene.play("Cutscene")
