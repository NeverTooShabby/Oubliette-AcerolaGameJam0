extends Node
@onready var gameMode = $VBoxContainer/GameMode


func _on_button_2_button_down():
	GameManager.toggleState()
	pass # Replace with function body.


func _process(delta):
	gameMode.text = str(GameManager.state)
