extends Node

enum GameState {FIELDVIEW, HANDVIEW}
var state : GameState = GameState.HANDVIEW

var playerField : Field

var mainCam : Camera3D
var handCam : Camera3D
var playerHand : Hand

var playerScore : int = 0

var aberrationNumber : int = 1

var curTarget : int = 0


const gridSize: float = 1.0 #size of boxes making up field grid

signal toggle_game_paused(isPaused : bool)

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func calcPlayerScore():
	var placeables : Array[Placeable] #it might make sense to keep this array in Field, but checking score by incrementing through field slots makes sense because I can check neighbors and global effects at the same time
	#except not quite. Score for each placeable, including effects should be calculated after any change is made in case I want to report on the grid or some shit
	for slot : FieldSlot in playerField.fieldSlots:
		var slotPlaceable = slot.pieceInSlot
		if slotPlaceable and not placeables.has(slotPlaceable):
			playerScore +=  slotPlaceable.curVal

func ColorFromCardDataEnum(colorIndex : CardData.CardColor) -> Color:
	var color : Color
	match colorIndex:
		CardData.CardColor.RED:
			color = Color.RED
		CardData.CardColor.BLUE:
			color = Color.BLUE
		CardData.CardColor.GREEN:
			color = Color.GREEN
		CardData.CardColor.COLORLESS:
			color = Color.WHITE
	return color

func PlaceablePlaced(placed : Placeable, placedField : Field, fieldSlots : Array):
	#field slots is an array of fieldslots for playing effects
	placed.piecePlaced(placedField)
	for slot in fieldSlots:
		slot.isOccupied = true
		slot.pieceInSlot = placed
	#reparent to field, play effects
	await SignalBus.PiecePlaceFinished
	calcPlayerScore()
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
	
func DealAberration():
	playerHand.dealAberrations()

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
		
func _input(event : InputEvent):
	if(event.is_action_pressed("menu")):
		game_paused = !game_paused
