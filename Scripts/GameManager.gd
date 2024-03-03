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
	await SignalBus.PiecePlaceFinished
	toggleState()
	pass
	
func AddCardToHand(cardData : CardData):
	playerHand.dealCards(1)
	
func PlayCard(playedCard : Card):
	toggleState()
	playerField.playedPiece(playedCard)
	pass
	
func DealHand():
	playerHand.dealCards(5)

func toggleState():
	if state == GameState.FIELDVIEW:
		state = GameState.HANDVIEW
		playerHand.set_process_input(true)
		playerHand.visible = true
		playerHand.returnToHandView()
		playerField.set_process_input(false)
		
	else:
		state = GameState.FIELDVIEW
		playerHand.visible = false
		playerField.set_process_input(true)
		playerHand.set_process_input(false)
		
func _input(event):
	#handle pause menu shit right here
	pass
