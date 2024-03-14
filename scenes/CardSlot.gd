extends Node3D
class_name CardSlot

var heldCard : Card

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#there is a reason this is in card slot... probably has something to do with animating the card independently
func select():
	heldCard.targetPosition.y = heldCard.selectedHeight
	var soundInt : int = randi_range(0,AudioLibrary.paperFlicks.size()-1)
	AudioManager.PlaySound(AudioLibrary.paperFlicks[soundInt], 0.8, 0.0, 0.5, 0.0, self)
	
func deselect():
	heldCard.targetPosition.y = 0.0

func _physics_process(delta):
	pass
