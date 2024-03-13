extends Node3D
class_name Hand

var cardSlots : Array
var slotTargets : Array
var cardSpacing : float = 0.2
var cardWidth : float = 1.0 #might want to pull from card
var queueDeleteSlot : CardSlot

@export var fixedCardRef : Node3D
@export var leftAberrationRef : Node3D
@export var rightAberrationRef : Node3D


@onready var cardGenerator : CardGenerator = $CardGenerator

enum DEAL_TYPE {ABERRATION, CARD}
var curDealType : DEAL_TYPE

enum QUEUED_MOVE {NONE, MOVE_LEFT, MOVE_RIGHT, SELECT, ZOOM_ON_CARD, VIEW_BOARD, BACK} #zoom in on card and view board are stretch goals
var moveQueue : QUEUED_MOVE = QUEUED_MOVE.NONE
var selectedSlot : CardSlot
var queueInputsOn : bool = false
var isPlaying : bool
var backTimer : float = 0.0
var timeToBack : float = 0.2

func setDealType(newDealType : DEAL_TYPE):
	#other fiddly stuff can go here - turning off inputs or something
	curDealType = newDealType

func addCard(newCardData : CardData):
	setupCardSlots()
	resizeHand(1)
	var newCardSlot = cardSlots[-1]
	var newCard = load("res://scenes/card.tscn").instantiate() #this throws an error/warrning, because the viewport texture is not defined or some shit. Doesn't cause a crash so I'm leaving it in
	newCardSlot.add_child(newCard) #probably need to add animation here
	newCardSlot.heldCard = newCard
	newCard.deal()
	newCard.data = newCardData
	
func addAberrationCard(newAberrationCardData : AberrationCardData):
	var newAbberationCard = load("res://scenes/aberrationCard.tscn").instantiate() #this throws an error/warrning, because the viewport texture is not defined or some shit. Doesn't cause a crash so I'm leaving it in
	var thisCardSlot = cardSlots[-1]
	thisCardSlot.add_child(newAbberationCard) #probably need to add animation here
	thisCardSlot.heldCard = newAbberationCard
	newAbberationCard.aberrationCardData = newAberrationCardData
	newAbberationCard.deal()
	
func reparentCards():
	for slot : CardSlot in cardSlots:
		slot.heldCard.reparent(self.get_parent_node_3d())
		
		
func parentBack():
	for slot : CardSlot in cardSlots:
		if slot.heldCard:
			slot.heldCard.reparent(slot)
	
func resizeHand(changeHandSize : int):
	var numCards : int = cardSlots.size()
	reparentCards()	
	
	if changeHandSize > 0:
		position.x = -0.5 * (cardWidth + cardSpacing) * numCards
		
		var newCardSlot : CardSlot = CardSlot.new()
		add_child(newCardSlot)
		newCardSlot.position.x = (cardWidth + cardSpacing) * cardSlots.size()
		cardSlots.append(newCardSlot)
		
	else:
		position.x = -0.5 * (cardWidth + cardSpacing) * (numCards - 1) #not 100% on why this has to be -1. Trust
		
		#var minCardX = (((numCards * cardWidth) + ((numCards - 1) * cardSpacing)) * -0.5) + (0.5 * cardWidth)
		for i : int in range(0, numCards):
			cardSlots[i].position.x = ((cardWidth + cardSpacing) * i)
			
	parentBack()
	
func dealCards(numCards : int):
	if(selectedSlot and cardSlots.size() > 0):
		selectedSlot.deselect()
	for i : int in range(numCards):
		addCard(cardGenerator.GenerateCard())
		var soundInt : int = randi_range(0,AudioLibrary.paperFlicks.size()-1)
		AudioManager.PlaySound(AudioLibrary.paperFlicks[soundInt], 1.0, 0.0, 0.5, 0.0, self)
		await SignalBus.CardDelt
	if(numCards > 1):
		selectSlot(cardSlots[floor(numCards/2.0)])
	else:
		selectSlot(cardSlots[-1])
		
func dealAberrations():
	var leftCardSlot : CardSlot = CardSlot.new()
	leftAberrationRef.add_child(leftCardSlot)
	cardSlots.append(leftCardSlot)
	addAberrationCard(cardGenerator.GenerateAberration(true))
		
	await SignalBus.CardDelt
	
	var rightCardSlot : CardSlot = CardSlot.new()
	rightAberrationRef.add_child(rightCardSlot)
	cardSlots.append(rightCardSlot)
	addAberrationCard(cardGenerator.GenerateAberration(false))
	await SignalBus.CardDelt
	
	selectSlot(cardSlots[-1])
	
	pass
	
func setupCardSlots():
		#this is just here for testing. slot array and held card should be dynamically assigned during dealing
	if cardSlots.size() == 0:
		for slot in get_children():
			if slot is CardSlot:
				slot.findHeldCard()
				cardSlots.append(slot)
	
func playCard(slot : CardSlot):
	isPlaying = true
	slot.heldCard.play()
	await SignalBus.CardPlayAnimationComplete
	GameManager.PlayCard(slot.heldCard)
	queueDeleteSlot = slot
	#TODO delete slot and draw new one when returning to hand if card placed
	#cardSlots.erase(slot)
	#slot.queue_free()
	
#call before returning to hand if backing out
func clearDeleteSlotQueue():
	queueDeleteSlot = null

	
func returnToHandView(wasCardPlayed : bool = false):
	if(queueDeleteSlot):
		cardSlots.erase(queueDeleteSlot)
		queueDeleteSlot.queue_free()
		queueDeleteSlot = null

	queueInputsOn = true
	isPlaying = false
	
	if cardSlots.size() != 0:
		resizeHand(0)
		selectCenterCard()
		if cardSlots.size() < 5:
			await get_tree().create_timer(0.5).timeout
			dealCards(5-cardSlots.size())

func selectSlot(slot : CardSlot):
	deselectAllSlots()
	
	#selectedSlot = slot
	#slot.select()
	
	#??? This was how it was before. Seems like how it should be, but was stalling here until next input?
	if not isPlaying:
		selectedSlot = slot
		slot.select()
	
func deselectAllSlots():
	for slot : CardSlot in cardSlots:
		slot.deselect()

func _input(event : InputEvent ):
		if Input.is_action_just_pressed("left"):
			moveQueue = QUEUED_MOVE.MOVE_LEFT
		elif Input.is_action_just_pressed("right"):
			moveQueue = QUEUED_MOVE.MOVE_RIGHT
		elif Input.is_action_just_pressed("select"):
			moveQueue = QUEUED_MOVE.SELECT
		elif Input.is_action_just_pressed("interact"):
			moveQueue = QUEUED_MOVE.BACK
			
	
			
func playAberration(slot : CardSlot):
	isPlaying = true
	slot.heldCard.play()
	var cardToPlay = slot.heldCard
	await SignalBus.CardPlayAnimationComplete
	
	#delete all cards and clear the array of card slots
	selectedSlot.deselect()
	
	for cardslot in cardSlots:
		cardslot.queue_free()
		
	cardSlots.clear()
	
	GameManager.PlayAberration(cardToPlay)
	
			
func handleInputs(delta):
	match moveQueue:
		QUEUED_MOVE.MOVE_LEFT:
			moveLeft()
				
		QUEUED_MOVE.MOVE_RIGHT:
			moveRight()
			
		QUEUED_MOVE.BACK:
			for cardslot in cardSlots:
				cardslot.queue_free()
	
			cardSlots.clear()
			GameManager.CompareScores()
				#move game manager to score comparison
		QUEUED_MOVE.SELECT:
			if curDealType == DEAL_TYPE.CARD:
				if not selectedSlot: #in case shit isn't getting selected right. This is a hack
					selectedSlot = cardSlots[-1]
				playCard(selectedSlot)
			elif curDealType == DEAL_TYPE.ABERRATION:
				playAberration(selectedSlot)
			
	moveQueue = QUEUED_MOVE.NONE
	#for now this doesn't do anything, will possibly come into play when animations are involved, but pretty sure those will be handeled on per slot basis
	
func selectCenterCard():
	var numCards : int = cardSlots.size()
	if numCards > 0:
		selectSlot(cardSlots[floor(numCards/2.0)])
	
func moveRight():
	if cardSlots.size() > 1: #should probably give some feedback when it is zero or one. A shake and honk maybe.
		var curIndex : int = cardSlots.find(selectedSlot)
		
		if curIndex != cardSlots.size() - 1:
			selectSlot(cardSlots[curIndex + 1])
		else:
			selectSlot(cardSlots[0])
			
func moveLeft():
	if cardSlots.size() > 1: #should probably give some feedback when it is zero or one. A shake and honk maybe.
		var curIndex : int = cardSlots.find(selectedSlot)
		
		if curIndex != 0:
			selectSlot(cardSlots[curIndex - 1])
		else:
			selectSlot(cardSlots[-1])
			
func _physics_process(delta):
	if queueInputsOn: #hacky bullshit
		self.set_process_input(true)
		queueInputsOn = false
	if moveQueue != QUEUED_MOVE.NONE:
		if not isPlaying:
			handleInputs(delta)
		else:
			moveQueue = QUEUED_MOVE.NONE #cancel moves entered while play animation is active
