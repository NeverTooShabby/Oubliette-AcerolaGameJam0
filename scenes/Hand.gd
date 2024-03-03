extends Node3D
class_name Hand

var cardSlots : Array
var slotTargets : Array
var cardSpacing : float = 0.2
var cardWidth : float = 1.0 #might want to pull from card

@onready var cardGenerator : CardGenerator = $CardGenerator

enum QUEUED_MOVE {NONE, MOVE_LEFT, MOVE_RIGHT, SELECT, ZOOM_ON_CARD, VIEW_BOARD} #zoom in on card and view board are stretch goals
var moveQueue : QUEUED_MOVE = QUEUED_MOVE.NONE
var selectedSlot : CardSlot

func addCard(newCardData : CardData):
	setupCardSlots()
	resizeHand(1)
	var newCardSlot = cardSlots[-1]
	var newCard = load("res://scenes/card.tscn").instantiate() #this throws an error/warrning, because the viewport texture is not defined or some shit. Doesn't cause a crash so I'm leaving it in
	newCardSlot.add_child(newCard) #probably need to add animation here
	newCardSlot.heldCard = newCard
	newCard.data = newCardData
	
func resizeHand(changeHandSize : int):
	#TODO animate these position changes
	if changeHandSize > 0:
		#should be slot.targetposition, then lerp there on physics process
		if cardSlots.size() == 0:
			position.x = 0
		else:
			position.x -= 0.5 * (cardWidth + cardSpacing)
		var newCardSlot : CardSlot = CardSlot.new()
		add_child(newCardSlot)
		newCardSlot.position.x = (cardWidth + cardSpacing) * cardSlots.size()
		cardSlots.append(newCardSlot)
		
	else:
		print("resizing down")
		var numCards = cardSlots.size()
		if numCards == 1:
			position.x = 0
			cardSlots[0].position.x = 0
		elif numCards > 0:
			position.x += 0.5 * (cardWidth + cardSpacing)
			#var minCardX = (((numCards * cardWidth) + ((numCards - 1) * cardSpacing)) * -0.5) + (0.5 * cardWidth)
			for i in range(0, numCards-1):
				cardSlots[i].position.x = ((cardWidth + cardSpacing) * i)
	pass
	
func dealHand():
	var handSize : int = 5 #TODO this should come from somewhere else... gamemanager probablyt
	for i in range(handSize):
		addCard(cardGenerator.GenerateCard())
	selectSlot(cardSlots[floor(handSize/2.0)])
	
func playLastCard():
	setupCardSlots()
	playCard(cardSlots[-1])
	
func setupCardSlots():
		#this is just here for testing. slot array and held card should be dynamically assigned during dealing
	if cardSlots.size() == 0:
		for slot in get_children():
			if slot is CardSlot:
				slot.findHeldCard()
				cardSlots.append(slot)
	
func playCard(slot : CardSlot):
	cardSlots.erase(slot)
	resizeHand(-1)
	GameManager.PlayCard(slot.heldCard)
	slot.queue_free()
	
func setTargets():
	for i in range(cardSlots.size()):
		pass
		
func selectSlot(slot : CardSlot):
	selectedSlot = slot
	slot.select()

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
			var numCards : int = cardSlots.size()
			if numCards > 0:
				selectSlot(cardSlots[floor(numCards/2.0)])
				
	moveQueue = QUEUED_MOVE.NONE
	#for now this doesn't do anything, will possibly come into play when animations are involved, but pretty sure those will be handeled on per slot basis
	
func moveRight():
	if cardSlots.size() > 1: #should probably give some feedback when it is zero or one. A shake and honk maybe.
		var curIndex : int = cardSlots.find(selectedSlot)
		selectedSlot.deselect()
		
		if curIndex != cardSlots.size() - 1:
			selectSlot(cardSlots[curIndex + 1])
		else:
			selectSlot(cardSlots[0])
			
func moveLeft():
	if cardSlots.size() > 1: #should probably give some feedback when it is zero or one. A shake and honk maybe.
		var curIndex : int = cardSlots.find(selectedSlot)
		selectedSlot.deselect()
		
		if curIndex != 0:
			selectSlot(cardSlots[curIndex - 1])
		else:
			selectSlot(cardSlots[-1])
func _physics_process(delta):
	if moveQueue != QUEUED_MOVE.NONE:
		handleInputs()

func SpreadCards():
	pass
