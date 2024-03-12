extends Node3D
@onready var trap_door_shape_rigid : RigidBody3D = $"trap_door_shape-rigid"
@onready var tdHinge : HingeJoint3D = $"trap_door_shape-rigid/HingeJoint3D"
@onready var light : MeshInstance3D= $Light

var time : float = 0
var bumpTimer : float
var bumpTimerMin : float = 1.0
var bumpForce : float = 0.5

var calmTimer : float = 2.0
var calmForce : float = 0.5
var playTimer : float = 1.0
var playForce : float = 1.0
var checkTimer : float = 0.3
var checkForce : float = 1.5

var explodeForce : float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	bumpTimer = bumpTimerMin
	check()
	pass # Replace with function body.

func calm():
	bumpForce = calmForce
	bumpTimerMin = calmTimer
	bumpTimer = bumpTimerMin
	
func play():
	bumpForce = playForce
	bumpTimerMin = playTimer
	bumpTimer = bumpTimerMin
	
func check():
	bumpForce = checkForce
	bumpTimerMin = checkTimer
	bumpTimer = bumpTimerMin
	
func explode():
	print(tdHinge.node_a)
	bumpForce = explodeForce
	bump()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func bump():
	var variedForce = bumpForce + randf()*bumpForce*3
	trap_door_shape_rigid.apply_torque_impulse(Vector3(-1*bumpForce,0.0,0.0))
	bumpTimer = bumpTimerMin + randf()*bumpTimerMin
	
func _physics_process(delta):
	time += delta
	bumpTimer -= delta
	
	light.mesh.material.emission_texture.noise.offset.y = light.mesh.material.emission_texture.noise.offset.y + delta * 100
	if light.mesh.material.emission_texture.noise.offset.y > 999:
		light.mesh.material.emission_texture.noise.offset.y = -1000
	
	if bumpTimer < 0:
		bump()
		
	if time > 5:
		explode()


func _on_rigid_body_3d_body_entered(body):
	if(time > 0.1):
		var randInt : int = randi_range(0,AudioLibrary.clinks.size()-1)
		AudioManager.PlaySound(AudioLibrary.clinks[randInt], 1.0, 0.0, 0.01, 0.0, self)



func _on_trap_door_shaperigid_body_entered(body):
	#don't like this shit but clock's a tickin
	if(body.name == "env_collider" and time > 0.1):
		var randInt : int = randi_range(0,AudioLibrary.thumps.size()-1)
		AudioManager.PlaySound(AudioLibrary.thumps[randInt], 1.0, 0.0, 0.01, 0.0, self)
