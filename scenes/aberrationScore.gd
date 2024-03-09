extends MeshInstance3D
class_name AberrationScore
@onready var scoreDisplay = $SubViewport/Label

var isTrapDoorViewTweening : bool = false

var aberrationScore : int:
	set(value):
		print("aberration score changed")
		aberrationScore = value
		scoreDisplay.text = str(aberrationScore)
		light()

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.aberrationScore = self
	visible = false
	SignalBus.trapDoorViewTweenStart.connect(_trapDoorViewTweenStart)
	SignalBus.trapDoorViewTweenComplete.connect(_trapDoorViewTweenComplete)
	
	pass # Replace with function body.
	
#I'm doing this as a mesh instance hopefully so I can do some cool disolve shader shit on it. But I don't know how to od that, Do I?
func _trapDoorViewTweenStart():
	isTrapDoorViewTweening = true

func _trapDoorViewTweenComplete():
	isTrapDoorViewTweening = false

func light():
	visible = true
	mesh.material.albedo_color = Color(1,1,1,0)
	if isTrapDoorViewTweening:
		await SignalBus.trapDoorViewTweenComplete
	
	var tween = get_tree().create_tween()
	tween.tween_property(mesh.material, "albedo_color", Color(1,0,0,1), 1)
	tween.tween_callback(_tween_finished)
	
func _tween_finished():
	SignalBus.AberrationAnimationComplete.emit()
	
func extinguish():
	visible = false
	#animate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
