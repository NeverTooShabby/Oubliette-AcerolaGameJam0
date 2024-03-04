extends Node3D
class_name Placer

var heldObj : Placeable


enum QUEUED_MOVE {NONE, MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN, ROT_CW, ROT_CCW, PLACE} #one button is rot is simpler
var moveQueue : QUEUED_MOVE

enum MOVE_TYPE {TRANSLATE, ROTATE, NONE} #one button is rot is simpler
var curMove : MOVE_TYPE


var isMoving : bool = false

var active : bool = true

var targetPosition : Vector3
var targetRotation : Vector3
var move_t : float
var lerpScale : float = 2.0


#TODO this needs to be reworked to either take an exisitng placeable as a parameter, or take the parameters of a new placeable (shape, #units, color) and generate a new one. As is is for testing
func newPlaceable(newData : CardData):
	position = Vector3.ZERO #new items spawn at center, move from there
	var newObj = load(newData.placeableObjectResourcePath).instantiate()
	
	add_child(newObj)
	heldObj = newObj
	heldObj.piecePickedUp()
	
	#TODO this should be done in placeable, pass the newData and calculate all this shit
	heldObj.setColor(newData.cardColor)
	heldObj.baseVal = newData.baseValue
	heldObj.curVal = newData.baseValue
	print(heldObj.curVal)
	
	
	
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
			
		if Input.is_action_just_pressed("test"):
			print("test called from placer")
			
			pass

func handleInputs():
	if moveQueue == QUEUED_MOVE.PLACE and heldObj:
		if heldObj.checkValidPlacement():
			GameManager.PlaceablePlaced(heldObj, self.get_parent_node_3d(), heldObj.get_fieldSlots())
			heldObj = null
		else:
			AudioManager.PlaySound(AudioLibrary.negativePlacementSound, 1.0, 0.05, 1.0, 0.0, self)
			#negative effect, shake?
			pass
		moveQueue = QUEUED_MOVE.NONE
			
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
	if heldObj.checkForMove(moveVector, rotVector, self):
		targetPosition = position + moveVector
		targetRotation = heldObj.rotation + rotVector
		isMoving = true
		move_t = 0.0
		return true #not sure if return gets used anywhere
	
	AudioManager.PlaySound(AudioLibrary.negativeMoveSound, 1.0, 0.05, 1.0, 0.0, self)
	return false
	
func moveEnd():
	isMoving = false
	curMove = MOVE_TYPE.NONE
	#TODO add sound here

func processMove():
	match curMove:
		MOVE_TYPE.TRANSLATE:
			position = position.lerp(targetPosition, move_t * lerpScale)
			if position.is_equal_approx(targetPosition):
				moveEnd()

		MOVE_TYPE.ROTATE:
			heldObj.rotation = heldObj.rotation.lerp(targetRotation, move_t * lerpScale)
			if heldObj.rotation.is_equal_approx(targetRotation):
				moveEnd()

func _physics_process(delta):
	if isMoving: #should probably use a new state for this
		move_t += delta
		processMove()
	else:
		handleInputs()
