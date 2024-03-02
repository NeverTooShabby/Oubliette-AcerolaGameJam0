extends Camera3D

@onready var cardSlots = $CardSlots

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.handCam = self #absolutely fucked way to do this
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
