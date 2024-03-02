extends Node3D

var cardSlots : Array
var slotTargets : Array

func addCard(newCard : Card):
	cardSlots.append(CardSlot.new())
	cardSlots[-1].add_child(newCard)
	
func playLastCard():
	#this is just here for testing. slot array and held card should be dynamically assigned during dealing
	if cardSlots.size() == 0:
		for slot in get_children():
			if slot is CardSlot:
				slot.findHeldCard()
				cardSlots.append(slot)
	print(cardSlots)
	playCard(cardSlots[-1])
	
func playCard(slot : CardSlot):
	cardSlots.erase(slot)
	GameManager.PlayCard(slot.heldCard)
	slot.queue_free()
	
func setTargets():
	for i in range(cardSlots.size()):
		pass

func SpreadCards():
	pass
