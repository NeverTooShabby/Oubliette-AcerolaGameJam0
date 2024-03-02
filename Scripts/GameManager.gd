extends Node

enum GameState {FIELDVIEW, HANDVIEW}
var state : GameState = GameState.HANDVIEW

var mainCam : Camera3D
var handCam : Camera3D


const gridSize: float = 1.0 #size of boxes making up field grid

func PlaceablePlaced(placed : Placeable, placedField : Field, fieldSlots : Array):
	#field slots is an array of fieldslots for playing effects
	placed.piecePlaced(placedField)
	for slot in fieldSlots:
		slot.isOccupied = true
	#reparent to field, play effects
	pass

func toggleState():
	if state == GameState.FIELDVIEW:
		state = GameState.HANDVIEW
		handCam.visible = true
	else:
		state = GameState.FIELDVIEW
		handCam.visible = false
