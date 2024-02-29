extends Node3D

class_name Field
var rows : int = 3
var cols : int = 3
@onready var boundingBoxArea : Area3D = $boundingBox
@onready var boundingBoxShape3D : CollisionShape3D = $boundingBox/CollisionShape3D
var boundingBox : BoxShape3D
@onready var maxPoint : Node3D = $maxPoint #use these instead of calculating the values on the fly in case of headaches arising if this ends up in a non-cardinal world position
@onready var minPoint : Node3D = $minPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	boundingBox = boundingBoxShape3D.shape
	boundingBox.size.x = cols * GameManager.gridSize
	boundingBox.size.z = rows * GameManager.gridSize
	
	maxPoint.position = Vector3(boundingBox.size.x/2, 0, boundingBox.size.z/2)
	minPoint.position = Vector3(-1 * boundingBox.size.x/2, 0, -1 * boundingBox.size.z/2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
