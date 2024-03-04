extends Node3D
class_name Placeable

const BAD_PLACEMENT = preload("res://materials/badPlacement.tres")
const GOOD_PLACEMENT = preload("res://materials/goodPlacement.tres")




@onready var ghost : Node3D = $ghost
@onready var segment_areas_node : Node3D = $SegmentAreas
@onready var selectionBorder : MeshInstance3D = $SelectionBorder
@onready var visual_mesh : PlaceableVisualMesh = $VisualMesh
@onready var decal = $VisualMesh/Decal

var baseVal : int
var curVal : int

var ghostPts : Array
var segmentAreas : Array

var isMoving : bool
var placementValid : bool

enum State {NONE, HELD, PLACED, LOCKED}
var currentState : State = State.NONE


func selectionBorderColor(goodPlacement : bool = placementValid):
	if(goodPlacement):
		selectionBorder.set_surface_override_material(0, GOOD_PLACEMENT)
	else:
		selectionBorder.set_surface_override_material(0, BAD_PLACEMENT)
		
func piecePickedUp():
	currentState = State.HELD
	visual_mesh.PickUp()


func piecePlaced(placedField : Field):
	selectionBorder.visible=false
	currentState = State.PLACED
	visual_mesh.PutDown()
	AudioManager.PlaySound(AudioLibrary.positivePlacementSound, 1.0, 0.05, 1.0, 0.0, self)
	#do something to move into position... project texture onto field? probably trigger this from GM
	await SignalBus.PiecePlaceFinished
	reparent(placedField)
	
func get_fieldSlots() -> Array:
	var fieldSlots : Array
	for area in segmentAreas:
		for overlapArea in area.get_overlapping_areas():
			var overlapAreaParent = overlapArea.get_parent_node_3d()
			if overlapAreaParent is FieldSlot:
				fieldSlots.append(overlapAreaParent)
	return fieldSlots
# Called when the node enters the scene tree for the first time.
func _ready():
	selectionBorderColor(true)
	for obj in segment_areas_node.get_children():
		if obj is Area3D:
			segmentAreas.append(obj)
	visual_mesh.visible = false
	for pt in ghost.get_children():
		ghostPts.append(pt)
	pass # Replace with function body.

func checkValidPlacement() -> bool:
	var badPlacement : bool = false
	for fieldSlot in get_fieldSlots():
		if fieldSlot.isOccupied:
			badPlacement = true
			placementValid = false
			selectionBorderColor()
			return false #return here to end early, no need to check further if any square is not valid
	placementValid = true
	selectionBorderColor()
	return true
	
func setColor(newColor : CardData.CardColor):
	var color = GameManager.ColorFromCardDataEnum(newColor)
			
	visual_mesh.mesh.material.albedo_color = color
	decal.modulate = color
	pass

func _process(delta):
	pass
	
func checkForMove(move : Vector3, rot : Vector3, placerObj : Placer) -> bool:
	var goodMove : bool = true
	var field = placerObj.get_parent_node_3d()
	var curParent = get_parent_node_3d()
	
	ghost.global_position += move #TODO beyond the scope of the jam. only works if the field aligns with the global position. Should find other way, but reparenting to make it relative to the placer fucked everything up
	ghost.rotation += rot
	
	for pt in ghostPts:
		if (pt.global_position.x > field.maxPoint.global_position.x or pt.global_position.z > field.maxPoint.global_position.z or pt.global_position.x < field.minPoint.global_position.x or pt.global_position.z < field.minPoint.global_position.z):
			goodMove = false
	
	resetGhost()
	return goodMove
	

	
func _physics_process(delta):
	if currentState == State.HELD:
		checkValidPlacement()
	
func resetGhost():
	ghost.position = Vector3.ZERO #move ghost back to where it started
	ghost.rotation = Vector3.ZERO
