extends Node3D

@onready var hand : Hand = $Hand
@onready var camera : Camera3D = $HandCam


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.handCam = camera #absolutely fucked way to do this. Don't think it needs hand cam actually
	GameManager.playerHand = hand
	pass # Replace with function body.
	
func _input(event):
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
