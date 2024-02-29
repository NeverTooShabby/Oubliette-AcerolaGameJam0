extends Node3D

var heldObj : Placeable

enum QUEUED_MOVE {NONE, MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN, ROT_CW, ROT_CCW} #one button is rot is simpler
var moveQueue : QUEUED_MOVE 
var isMoving : bool = false
var targetPosition : Vector3
var targetRotation : Vector3

#TODO this should only be active during selection. Especially for inputs. Might want a state machine, or just control active inactive from game manager

func newPlaceable():
	if(!heldObj):
		var objtype = load("res://scenes/Placeable.tscn") #this don't seem right. I need to be able to instantiate one of the ominoes, rock, bomb? Maybe gamemanager holds a dictionary of all of these or better yet, it preloads all of them 
		var newobj = objtype.instantiate()
		add_child(newobj)
		heldObj = newobj
	
func _input(event):
	if heldObj: #TODO remove this safety when placer is properly controlled by gm and can't act when it's not holding something
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
			#drop obj if clear, else throw error and honk
			pass
	else:
		if Input.is_action_just_pressed("select"): #just for testing
			newPlaceable() 
		

func handleInputs():
	if moveQueue != QUEUED_MOVE.NONE: #how tf could this be none?
		var newPosition = checkMove(moveQueue)
		moveQueue = QUEUED_MOVE.NONE
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
	

	
	if heldObj.checkForMove(moveVector, rotVector, self.get_parent()):
		global_transform = heldObj.ghost.global_transform
		isMoving = false
	
	heldObj.resetGhost()
	
	return false

func processMove():
	pass
	
func _physics_process(delta):
	if isMoving:
		processMove()
	else:
		handleInputs()
