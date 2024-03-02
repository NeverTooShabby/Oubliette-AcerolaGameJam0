extends MeshInstance3D
class_name PlaceableVisualMesh

enum State {NONE, FLOAT, POSITION, INPOSITION}
var curState : State = State.NONE
var nextState : State

var sway_t : float = 0.0
var swayVertAmp : float = 0.05
var swayRotAmp : float = 0.025
var swayVertFreq : float = 0.1
var swayRotFreq : float = 0.2

const floatPos : Vector3 = Vector3(0, 0.2, 0)

var inPosition : bool = false

var targetRotation : Vector3
var targetPosition : Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	match curState:
		State.FLOAT:
			sway(delta)
		State.POSITION:
			moveToPosition()
		State.INPOSITION:
			pass
			
func sway(delta):
	sway_t += delta * 2 * PI
	position.y = swayVertAmp * sin(swayVertFreq * sway_t)
	rotation.z = swayRotAmp * sin(swayRotFreq * sway_t)
	
func assignNewTarget(newPos : Vector3):
	targetRotation = Vector3.ZERO
	targetPosition = newPos
	
func moveToPosition():
	position = position.lerp(targetPosition, 1.0)
	rotation = position.lerp(targetRotation, 1.0)
	
	if (position.is_equal_approx(targetPosition) and rotation.is_equal_approx(targetRotation)):
		changeState(nextState)
		
func PickUp():
	assignNewTarget(floatPos)
	nextState = State.FLOAT
	changeState(State.POSITION)
	
func PutDown():
	assignNewTarget(Vector3.ZERO)
	nextState = State.INPOSITION
	changeState(State.POSITION)
	

func changeState(newState : State):
	curState = newState
	match curState:
		State.FLOAT:
			visible = true
			inPosition = false
			#handle transparent visible
		State.POSITION:
			visible = true
			inPosition = false
			#handle transparency
			pass
		State.INPOSITION:
			visible = true
			inPosition = true
		
			pass
