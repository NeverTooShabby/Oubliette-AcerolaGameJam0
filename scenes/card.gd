extends Node3D
class_name Card

@onready var cardTitle : Label = $CardTitle
@onready var cardText : Label = $CardText

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
