extends Label

var playerScore=0
var botScore=0

func _process(_delta: float) -> void:
	text=str(playerScore) + " | " + str(botScore)
