extends Node

enum GameState {FIELDVIEW, HANDVIEW}
var state : GameState = GameState.HANDVIEW

var playerField : Field

var mainCam : Camera3D
var handCam : Camera3D
var playerHand : Hand




const gridSize: float = 1.0 #size of boxes making up field grid

func PlaceablePlaced(placed : Placeable, placedField : Field, fieldSlots : Array):
	#field slots is an array of fieldslots for playing effects
	placed.piecePlaced(placedField)
	for slot in fieldSlots:
		slot.isOccupied = true
	#reparent to field, play effects
	toggleState()
	pass
	
func AddCardToHand(cardData : CardData):
	print(cardData)
	playerHand.addCard(cardData)
	
func PlayCard(playedCard : Card):
	print(playedCard)
	toggleState()
	playerField.playedPiece(playedCard)
	pass
	
func DealHand():
	playerHand.dealHand()

func toggleState():
	if state == GameState.FIELDVIEW:
		state = GameState.HANDVIEW
		playerHand.visible = true
		playerHand.set_process_input(true)
		playerField.set_process_input(false)
		
	else:
		state = GameState.FIELDVIEW
		playerHand.visible = false
		playerField.set_process_input(true)
		playerHand.set_process_input(false)
		
func _input(event):
	#handle pause menu shit right here
	pass
