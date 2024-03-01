extends Node3D

var heldObj : Placeable

enum QUEUED_MOVE {NONE, MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN, ROT_CW, ROT_CCW, PLACE} #one button is rot is simpler
var moveQueue : QUEUED_MOVE

enum MOVE_TYPE {TRANSLATE, ROTATE, NONE} #one button is rot is simpler
var curMove : MOVE_TYPE

var isMoving : bool = false

var active : bool = true

var startTransform : Transform3D
var targetTransform : Transform3D
var move_t : float
var lerpScale : float = 2.0


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
			moveQueue = QUEUED_MOVE.PLACE
			
			#drop obj if clear, else throw error and honk
			pass
	else:
		if Input.is_action_just_pressed("select"): #just for testing
			newPlaceable() 
		

func handleInputs():
	if moveQueue == QUEUED_MOVE.PLACE and heldObj:
		if heldObj.checkValidPlacement():
			GameManager.PlaceablePlaced(heldObj, self.get_parent_node_3d(), heldObj.get_fieldSlots())
			moveQueue = QUEUED_MOVE.NONE
			heldObj = null
		else:
			#honka honka
			#negative effect, shake?
			pass
	elif moveQueue != QUEUED_MOVE.NONE: #how tf could this be none?
		checkMove(moveQueue)
		moveQueue = QUEUED_MOVE.NONE
	#else: possible timeout for buffer limit

func checkMove(move : QUEUED_MOVE) -> bool:
	var moveVector : Vector3 = Vector3.ZERO
	var rotVector : Vector3 = Vector3.ZERO
	curMove = MOVE_TYPE.TRANSLATE
	
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
			curMove = MOVE_TYPE.ROTATE
			rotVector.y = -1*PI/2
	
	#TODO move this to process move with lerp
	if heldObj.checkForMove(moveVector, rotVector, self.get_parent()):
		targetTransform = heldObj.ghost.global_transform
		heldObj.resetGhost()
		isMoving = true
		move_t = 0.0
		return true #not sure if return gets used anywhere
	
	heldObj.resetGhost()
	
	return false
	
func moveEnd():
	isMoving = false
	curMove = MOVE_TYPE.NONE
	#TODO add sound here

func processMove():
	var transformObj : Node3D
	match curMove:
		MOVE_TYPE.TRANSLATE:
			transformObj = self

		MOVE_TYPE.ROTATE:
			transformObj = heldObj

	transformObj.global_transform = transformObj.global_transform.interpolate_with(targetTransform, move_t * lerpScale)
	
	if transformObj.global_transform.is_equal_approx(targetTransform):
		moveEnd()

	
func _physics_process(delta):
	if isMoving: #should probably use a new state for this
		move_t += delta
		processMove()
	else:
		handleInputs()
