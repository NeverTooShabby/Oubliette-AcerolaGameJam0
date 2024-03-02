extends Node

enum GameState {FIELDVIEW, HANDVIEW}
var state : GameState = GameState.HANDVIEW

var PlayerField : Field

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
	
func PlayCard(playedCard : Card):
	print(playedCard)
	toggleState()
	PlayerField.playedPiece(playedCard)
	pass

func toggleState():
	if state == GameState.FIELDVIEW:
		state = GameState.HANDVIEW
		playerHand.visible = true
	else:
		state = GameState.FIELDVIEW
		playerHand.visible = false
