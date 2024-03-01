extends MeshInstance3D
class_name PlaceableVisualMesh

enum State {NONE, FLOAT, POSITION, INPOSITION}
var curState : State = State.NONE

var sway_t : float = 0.0
var swayVertAmp : float = 0.1
var swayRotAmp : float = PI
var swayVertFreq : float = 0.5
var swayRotFreq : float = 0.5

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
	rotation.y = swayRotAmp * sin(swayRotFreq * sway_t)
	pass
	
func assignNewTarget():
	targetRotation = Vector3.ZERO
	targetPosition = Vector3(0, -1 * GameManager.gridSize, 0)
	
func moveToPosition():
	position = position.lerp(targetPosition, 1.0)
	rotation = position.lerp(targetRotation, 1.0)
	
	if (position.is_equal_approx(targetPosition) and rotation.is_equal_approx(targetRotation)):
		changeState(State.INPOSITION)
	

func changeState(newState : State):
	curState = newState
	match curState:
		State.FLOAT:
			visible = true
			#handle transparent visible
		State.POSITION:
			visible = true
			inPosition = false
			assignNewTarget()
			#handle transparency
			pass
		State.INPOSITION:
			visible = true
			inPosition = true
			pass
