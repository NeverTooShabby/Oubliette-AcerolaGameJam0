extends Node3D

class_name Placeable
@onready var ghost : Node3D = $ghost

var ghostPts : Array



# Called when the node enters the scene tree for the first time.
func _ready():
	for pt in ghost.get_children():
		ghostPts.append(pt)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func checkForMove(move : Vector3, rot : Vector3, field : Field) -> bool:
	var goodMove : bool = true
	ghost.position += move
	ghost.rotation += rot
	
	for pt in ghostPts:
		if (pt.global_position.x > field.maxPoint.global_position.x or pt.global_position.z > field.maxPoint.global_position.z or pt.global_position.x < field.minPoint.global_position.x or pt.global_position.z < field.minPoint.global_position.z):
			goodMove = false
	
	return goodMove
	
	
func resetGhost():
	ghost.global_transform = self.global_transform #move ghost back to where it started
	
