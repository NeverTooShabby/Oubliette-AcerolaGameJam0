extends MeshInstance3D
class_name PlaceableVisualMesh

enum State {NONE, FLOAT, POSITION, INPOSITION, PLACED}
var curState : State = State.NONE
var nextState : State

var sway_t : float = 0.0
var swayVertAmp : float = 0.05
var swayRotAmp : float = 0.025
var swayVertFreq : float = 0.1
var swayRotFreq : float = 0.2

var floatHeight : float = 0.2
var sinkDepth : float = -0.6
var undergroundTarget : Vector3 = Vector3(0, -0.6, 0) # used so the piece sinks under the ground and the decal is applied to  the surface of the ground

var inPosition : bool = false

var targetRotation : Vector3
var initialRotation : Vector3
var targetPosition : Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	initialRotation = rotation
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	match curState:
		State.FLOAT:
			sway(delta)
		State.POSITION:
			moveToPosition(delta)
		State.INPOSITION:
			pass
			
func sway(delta):
	sway_t += delta * 2 * PI
	position.y = floatHeight + swayVertAmp * sin(swayVertFreq * sway_t)
	rotation.z = swayRotAmp * sin(swayRotFreq * sway_t)
	
func assignNewTarget(newPos : Vector3):
	targetRotation = initialRotation
	targetPosition = newPos
	
func moveToPosition(delta):
	#TODO interpolation that isn't as ass slow on the back end. Either that or create own is equal approx with a higher tollerance
	position = position.lerp(targetPosition, 10.0 * delta)
	rotation = rotation.lerp(targetRotation, 10.0 * delta)
	
	
	if (position.is_equal_approx(targetPosition) and rotation.is_equal_approx(targetRotation)):
		changeState(nextState)
		
func PickUp():
	assignNewTarget(Vector3(position.x, floatHeight, position.z))
	nextState = State.FLOAT
	changeState(State.POSITION)
	
func PutDown():
	assignNewTarget(Vector3(position.x, sinkDepth, position.z))
	nextState = State.PLACED
	changeState(State.POSITION)
	

func changeState(newState : State):
	prints("state to change to",newState)
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
		State.PLACED:
			visible = true
			inPosition = true
			print("placed")
			SignalBus.PiecePlaceFinished.emit()
		
			pass
