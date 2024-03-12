extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rigid_body_3d_body_entered(body):
	var randInt : int = randi_range(0,AudioLibrary.clinks.size()-1)
	AudioManager.PlaySound(AudioLibrary.clinks[randInt], 1.0, 0.0, 0.8, 0.0, self)



func _on_trap_door_shaperigid_body_entered(body):
	#don't like this shit but clock's a tickin
	if(body.name == "env_collider"):
		var randInt : int = randi_range(0,AudioLibrary.thumps.size()-1)
		AudioManager.PlaySound(AudioLibrary.thumps[randInt], 1.0, 0.0, 0.8, 0.0, self)
