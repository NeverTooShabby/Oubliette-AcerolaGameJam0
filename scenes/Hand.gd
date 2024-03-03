extends Node3D
class_name Hand

var cardSlots : Array
var slotTargets : Array
var cardSpacing : float = 0.2
var cardWidth : float = 1.0 #might want to pull from card

@onready var cardGenerator : CardGenerator = $CardGenerator

func addCard(newCardData : CardData):
	setupCardSlots()
	resizeHand(1)
	var newCardSlot = cardSlots[-1]
	var newCard = load("res://scenes/card.tscn").instantiate()
	newCardSlot.add_child(newCard) #probably need to add animation here
	newCardSlot.heldCard = newCard
	newCard.data = newCardData
	
func resizeHand(changeHandSize : int):
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
	for i in range(5):
		addCard(cardGenerator.GenerateCard())
	
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

func SpreadCards():
	pass
