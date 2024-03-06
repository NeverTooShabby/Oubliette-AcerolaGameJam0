extends Node3D

class_name Field
var rows : int = 3
var cols : int = 3
@onready var boundingBoxArea : Area3D = $boundingBox
@onready var boundingBoxShape3D : CollisionShape3D = $boundingBox/CollisionShape3D
var boundingBox : BoxShape3D
var fieldSlots : Array[FieldSlot] #idk if I need this for anything
@onready var maxPoint : Node3D = $maxPoint #use these instead of calculating the values on the fly in case of headaches arising if this ends up in a non-cardinal world position
@onready var minPoint : Node3D = $minPoint
@onready var placer : Placer = $Placer

func setAsPlayerField():
	GameManager.playerField = self
	
func FindFieldSlotValues() -> Array[FieldSlot]:
	var slots : Array[FieldSlot]
	for child in get_children():
		if child is FieldSlot and not slots.has(child):
			slots.append(child)
			
	return slots
	
func playedPiece(newCard : Card):
	placer.newPlaceable(newCard.data)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.fieldViewCamera = $FieldViewCam
	fieldSlots = FindFieldSlotValues()
	setAsPlayerField() #TODO this needs to be done when the field is generated. One for player, one for enemy
	boundingBox = boundingBoxShape3D.shape
	boundingBox.size.x = cols * GameManager.gridSize
	boundingBox.size.z = rows * GameManager.gridSize
	
	maxPoint.position = Vector3(boundingBox.size.x/2, 0, boundingBox.size.z/2)
	minPoint.position = Vector3(-1 * boundingBox.size.x/2, 0, -1 * boundingBox.size.z/2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_field_view_cam_tween_completed():
	print("field cam tween complete")


func _on_field_view_cam_tween_started():
	print("field tween started")
