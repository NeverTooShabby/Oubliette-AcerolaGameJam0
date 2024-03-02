extends Node3D
class_name Hand

@onready var cardSlots = $CardSlots
@onready var camera = $HandCam


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.handCam = camera #absolutely fucked way to do this. Don't think it needs hand cam actually
	GameManager.playerHand = self
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
