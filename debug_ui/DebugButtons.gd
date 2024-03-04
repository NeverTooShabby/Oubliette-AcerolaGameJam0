extends Node
@onready var gameMode = $VBoxContainer/GameMode
@onready var player_score = $VBoxContainer/PlayerScore


func _on_button_2_button_down():
	GameManager.toggleState()
	pass # Replace with function body.


func _process(delta):
	pass
	
func _physics_process(delta):
	gameMode.text = str(GameManager.state)
	player_score.text = "Total Score: " + str(GameManager.playerScore)

func _on_add_card_button_down():
	GameManager.AddCardToHand(load("res://objects/placeables/TwoBlock.tres"))
	pass


func _on_deal_hand_pressed():
	GameManager.DealHand()
