extends Node3D
class_name Card

@export var data : CardData:
	set(value):
		var card_face = $Front
		var card_template = $Front/SubViewport/CardTemplate
		
		data = value
		
		card_template.get_node("Title").text = data.cardName
		card_template.get_node("CardText/Text").text = data.cardDescription
		card_template.get_nude("Art").texture = data.art
		
#apparently should delete viewport after instantiating to save resources. Probably won't be needed

var cardType
var cardImage
var cardColor #probably part of image class

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setCardDisplay(cardData : Object):
	#set title, image (image color if it isn't baked into the image), and text
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
