extends Node3D
class_name CardSlot

var heldCard : Card



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func findHeldCard():
	for child in get_children():
		if child is Card:
			heldCard = child

#there is a reason this is in card slot... probably has something to do with animating the card independently
func select():
	position.y = heldCard.selectedHeight
	
func deselect():
	position.y = 0
