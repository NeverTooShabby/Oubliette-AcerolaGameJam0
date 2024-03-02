extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.handCam = self #this is a pretty ass way to handle this, but imma let it ride


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
