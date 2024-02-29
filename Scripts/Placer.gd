extends Node3D

var heldObj : Placeable

enum QUEUED_MOVE {NONE, MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN, ROT_CW, ROT_CCW} #one button is rot is simpler
var moveQueue : QUEUED_MOVE 
var isMoving : bool = false
var targetPosition : Vector3
var targetRotation : Vector3

#TODO this should only be active during selection. Especially for inputs. Might want a state machine, or just control active inactive from game manager

func newPlaceable(obj : Placeable):
	add_child(obj)
	heldObj = obj
	
func _input(event):
	if Input.is_action_just_pressed("left"):
		moveQueue = QUEUED_MOVE.MOVE_LEFT
	elif Input.is_action_just_pressed("right"):
		moveQueue = QUEUED_MOVE.MOVE_RIGHT
	elif Input.is_action_just_pressed("up"):
		moveQueue = QUEUED_MOVE.MOVE_UP
	elif Input.is_action_just_pressed("down"):
		moveQueue = QUEUED_MOVE.MOVE_DOWN
	elif Input.is_action_just_pressed("cwRot"):
		moveQueue = QUEUED_MOVE.ROT_CW
		
	if Input.is_action_just_pressed("select"):
		newPlaceable(Placeable.new())
		

func handleInputs():
	if moveQueue != QUEUED_MOVE.NONE: #how tf could this be none?
		var newPosition = checkMove(moveQueue)
	#else: possible timeout for buffer limit
			
func checkMove(move : QUEUED_MOVE) -> bool:
	var checkRay : RayCast3D = RayCast3D.new()
	var moveVector : Vector3 = Vector3.ZERO
	var rotVector : Vector3 = Vector3.ZERO
	match move:
		QUEUED_MOVE.MOVE_UP:
			moveVector.z = -GameManager.gridSize
		QUEUED_MOVE.MOVE_DOWN:
			moveVector.z = GameManager.gridSize
		QUEUED_MOVE.MOVE_LEFT:
			moveVector.x = -GameManager.gridSize
		QUEUED_MOVE.MOVE_RIGHT:
			moveVector.x = GameManager.gridSize
		QUEUED_MOVE.ROT_CW:
			rotVector.y = -1*PI/2
	return false

func processMove():
	pass
	
func _physics_process(delta):
	if isMoving:
		processMove()
	else:
		handleInputs()
