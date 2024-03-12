extends Node


enum GameState {INTRO, FIELDVIEW, HANDVIEW, ABERRATIONVIEW, GAMEOVER} #ABERRATIONVIEW zooms in on trap door. For intro and for aberration selection
var state : GameState = GameState.INTRO
var nextState : GameState
var trapDoor : TrapDoor

var isReadyForRestart : bool = false

var aberrationCamera : PhantomCamera3D
var fieldViewCamera : PhantomCamera3D

var playerField : Field

var mainCam : Camera3D
var handCam : Camera3D
var playerHand : Hand

var playerScore : int = 0

var aberrationNumber : int = 0

var curTarget : int = 0

var aberrationScore : AberrationScore


const gridSize: float = 1.0 #size of boxes making up field grid

signal toggle_game_paused(isPaused : bool)

func _ready():
	await get_tree().create_timer(0.1).timeout
	toggleState(GameState.INTRO)

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
	playerScore = 0
	for slot : FieldSlot in playerField.fieldSlots:
		var slotPlaceable = slot.pieceInSlot
		if slotPlaceable and not placeables.has(slotPlaceable):
			placeables.append(slotPlaceable)
			playerScore +=  slotPlaceable.curVal
			
func newScore():
	nextState = GameState.HANDVIEW
	toggleState(GameState.ABERRATIONVIEW)
	trapDoor.play()
	await get_tree().create_timer(2).timeout
	curTarget = 30 + (10 * aberrationNumber)
	aberrationScore.aberrationScore = curTarget

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
	toggleState(GameState.HANDVIEW)
	pass
	
func backToHand():
	playerHand.clearDeleteSlotQueue()
	playerField.set_process_input(false)
	toggleState(GameState.HANDVIEW)
	
func AddCardToHand(cardData : CardData):
	playerHand.curDealType = playerHand.DEAL_TYPE.CARD	
	playerHand.dealCards(1)
	
func PlayCard(playedCard : Card):
	toggleState(GameState.FIELDVIEW)
	playerField.playedPiece(playedCard)
	pass
	
func PlayAberration(playedAberration : AberrationCard):
	nextState = GameState.HANDVIEW #this is in place for when end case/next aberration is implemented. Aberration view will be used as an inbetween, showing a distinc animation for each	
	curTarget = playedAberration.aberrationCardData.targetValue
	
	toggleState(GameState.ABERRATIONVIEW)
	aberrationScore.aberrationScore = curTarget
	#go to field view -- or new view -- to watch the score get set, possible other animations
	#return to hand view and deal cards
	pass
	
func DealHand():
	playerHand.curDealType = playerHand.DEAL_TYPE.CARD
	playerHand.dealCards(5)
	
func DealAberration():
	playerHand.curDealType = playerHand.DEAL_TYPE.ABERRATION
	playerHand.dealAberrations()

func toggleState(newState : GameState):
	match newState:
		GameState.INTRO:
			SignalBus.switchedToOtherState.emit()
			state = GameState.INTRO
			aberrationCamera.set_priority(20)
			playerField.set_process_input(false)
			#shouldn't have to do this for the placer, but something was turing the playerfield process input back on and I couldnt' find it
			playerField.placer.set_process_input(false)
			playerHand.set_process_input(false)
			SignalBus.IntroAnimStart.emit()
			
		GameState.HANDVIEW:
			
			#cam focus wide field view
			#if hand not empty, animate hand raising
			SignalBus.switchedToHandView.emit()
			aberrationCamera.set_priority(0)
			
			state = GameState.HANDVIEW
			playerHand.visible = true
			playerField.set_process_input(false)
			playerField.placer.set_process_input(false)
			playerHand.returnToHandView()
		GameState.FIELDVIEW:
			SignalBus.switchedToFieldView.emit()
			aberrationCamera.set_priority(0)
			print("switched to field view")
			#cam focus the field
			#if hand not empty, animate hand lowering
			state = GameState.FIELDVIEW
			playerHand.visible = false
			playerField.set_process_input(true)
			playerField.placer.set_process_input(true)
			
			playerHand.set_process_input(false)
		GameState.ABERRATIONVIEW:
			SignalBus.switchedToOtherState.emit()
			
			aberrationCamera.set_priority(20)
			print("switched to aberration view")
			
			#cam target the door
			state = GameState.ABERRATIONVIEW
			playerField.set_process_input(false)
			playerHand.set_process_input(false)
			playerField.placer.set_process_input(false)
			
			print("waiting for animation complete")
			await SignalBus.AberrationAnimationComplete
			print("animation complete")
			
			toggleState(nextState)
			DealHand()
			print("deal hand command processed")
		GameState.GAMEOVER:
			SignalBus.switchedToOtherState.emit()
			
			playerField.set_process_input(false)
			playerHand.set_process_input(false)
			playerField.placer.set_process_input(false)
			SignalBus.GameOverStart.emit()

		
func _input(event : InputEvent):
	if(event.is_action_pressed("menu")):
		game_paused = !game_paused
