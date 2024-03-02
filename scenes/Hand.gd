extends Node3D
class_name Hand

var cardSlots : Array
var slotTargets : Array
var cardSpacing : float = 1.2

func addCard(newCardData : CardData):
	setupCardSlots()
	var newCardSlot : CardSlot = CardSlot.new()
	add_child(newCardSlot)
	var newCard = load("res://scenes/card.tscn").instantiate()
	newCardSlot.add_child(newCard) #probably need to add animation here
	newCardSlot.heldCard = newCard
	newCard.data = newCardData
	newCardSlot.position.x = cardSlots[-1].position.x + cardSpacing
	cardSlots.append(newCardSlot)
	
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
	GameManager.PlayCard(slot.heldCard)
	slot.queue_free()
	
func setTargets():
	for i in range(cardSlots.size()):
		pass

func SpreadCards():
	pass
