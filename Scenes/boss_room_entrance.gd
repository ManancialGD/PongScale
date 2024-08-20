extends Area2D

signal player_entered_room(player: RPG_Player)

@export var rpg_enemy: RPG_Enemy
@onready var cutscene_end_timer: Timer = $CutsceneEndTimer


func _on_body_entered(body: Node2D) -> void:
	if rpg_enemy != null: return
	if body is RPG_Player:
		emit_signal("player_entered_room", body as RPG_Player)
		cutscene_end_timer.start()


func _on_cutscene_end_timer_timeout() -> void:
	queue_free()
