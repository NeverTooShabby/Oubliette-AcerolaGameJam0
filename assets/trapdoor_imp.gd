extends Node3D
class_name TrapDoor
@onready var trap_door_shape_rigid : RigidBody3D = $"trap_door_shape-rigid"
@onready var tdHinge : HingeJoint3D = $HingeJoint3D
@onready var light : MeshInstance3D= $Light

var time : float = 0
var bumpTimer : float
var bumpTimerMin : float = 1.0
var bumpForce : float = 0.5

var calmTimer : float = 1000
var calmForce : float = 0.5
var playTimer : float = 1.0
var playForce : float = 1.0
var checkTimer : float = 0.3
var checkForce : float = 1.5

var explodeFlag : bool = false

var explodeForce : float = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	bumpTimer = bumpTimerMin
	light.mesh.material.emission_energy_multiplier = 0.0
	GameManager.trapDoor = self
	calm()
	pass # Replace with function body.
	
func tween_emission_strength(newStrength : float):
	var tween2 = get_tree().create_tween()
	tween2.parallel().tween_property(light.mesh.material, "emission_energy_multiplier", newStrength, 1)
	
func calm():
	bumpForce = calmForce
	bumpTimerMin = calmTimer
	bumpTimer = bumpTimerMin
	tween_emission_strength(0.0)
	
func play():
	bumpForce = playForce
	bumpTimerMin = playTimer
	bumpTimer = bumpTimerMin
	tween_emission_strength(3.0)
	
	
func check():
	bumpForce = checkForce
	bumpTimerMin = checkTimer
	bumpTimer = bumpTimerMin
	tween_emission_strength(5.0)
	
	
func explode():
	tdHinge.node_a = ""
	trap_door_shape_rigid.apply_impulse(Vector3(0.0,explodeForce,0.0))
	bumpTimer = 1000
	explodeFlag = true
	tween_emission_strength(10.0)
	

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


func _on_rigid_body_3d_body_entered(body):
	if(time > 0.1):
		var randInt : int = randi_range(0,AudioLibrary.clinks.size()-1)
		AudioManager.PlaySound(AudioLibrary.clinks[randInt], 1.0, 0.0, 0.01, 0.0, self)



func _on_trap_door_shaperigid_body_entered(body):
	#don't like this shit but clock's a tickin
	if(body.name == "env_collider" and time > 0.1):
		var randInt : int = randi_range(0,AudioLibrary.thumps.size()-1)
		AudioManager.PlaySound(AudioLibrary.thumps[randInt], 1.0, 0.0, 0.01, 0.0, self)
