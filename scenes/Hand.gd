extends Node3D
class_name Hand

var cardSlots : Array
var slotTargets : Array
var cardSpacing : float = 0.2
var cardWidth : float = 1.0 #might want to pull from card

@export var fixedCardRef : Node3D
@onready var cardGenerator : CardGenerator = $CardGenerator

enum QUEUED_MOVE {NONE, MOVE_LEFT, MOVE_RIGHT, SELECT, ZOOM_ON_CARD, VIEW_BOARD} #zoom in on card and view board are stretch goals
var moveQueue : QUEUED_MOVE = QUEUED_MOVE.NONE
var selectedSlot : CardSlot

var isPlaying : bool

func addCard(newCardData : CardData):
	setupCardSlots()
	resizeHand(1)
	var newCardSlot = cardSlots[-1]
	var newCard = load("res://scenes/card.tscn").instantiate() #this throws an error/warrning, because the viewport texture is not defined or some shit. Doesn't cause a crash so I'm leaving it in
	newCardSlot.add_child(newCard) #probably need to add animation here
	newCardSlot.heldCard = newCard
	newCard.deal()
	newCard.data = newCardData

	
func reparentCards():
	for slot in cardSlots:
		slot.heldCard.reparent(self.get_parent_node_3d())
		
		
func parentBack():
	for slot in cardSlots:
		if slot.heldCard:
			slot.heldCard.reparent(slot)
	
func resizeHand(changeHandSize : int):
	var numCards = cardSlots.size()
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
		for i in range(0, numCards):
			cardSlots[i].position.x = ((cardWidth + cardSpacing) * i)
			
	parentBack()
	
func dealCards(numCards : int):
	if(selectedSlot and cardSlots.size() > 0):
		selectedSlot.deselect()
	for i in range(numCards):
		addCard(cardGenerator.GenerateCard())
		await SignalBus.CardDelt
	if(numCards > 1):
		selectSlot(cardSlots[floor(numCards/2.0)])
	else:
		selectSlot(cardSlots[-1])
	
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
	cardSlots.erase(slot)
	slot.queue_free()
	
func returnToHandView():
	resizeHand(0)
	isPlaying = false
	selectCenterCard()
		
func selectSlot(slot : CardSlot):
	deselectAllSlots()
	if not isPlaying:
		selectedSlot = slot
		slot.select()
	
func deselectAllSlots():
	for slot in cardSlots:
		slot.deselect()

func _input(event : InputEvent ):
		if Input.is_action_just_pressed("left"):
			moveQueue = QUEUED_MOVE.MOVE_LEFT
		elif Input.is_action_just_pressed("right"):
			moveQueue = QUEUED_MOVE.MOVE_RIGHT
		elif Input.is_action_just_pressed("select"):
			moveQueue = QUEUED_MOVE.SELECT
			
func handleInputs():
	match moveQueue:
		QUEUED_MOVE.MOVE_LEFT:
			moveLeft()
				
		QUEUED_MOVE.MOVE_RIGHT:
			moveRight()
			
		QUEUED_MOVE.SELECT:
			playCard(selectedSlot)
				
	moveQueue = QUEUED_MOVE.NONE
	#for now this doesn't do anything, will possibly come into play when animations are involved, but pretty sure those will be handeled on per slot basis
	
func selectCenterCard():
	var numCards = cardSlots.size()
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
	if moveQueue != QUEUED_MOVE.NONE:
		if not isPlaying:
			handleInputs()
		else:
			moveQueue = QUEUED_MOVE.NONE #cancel moves entered while play animation is active
