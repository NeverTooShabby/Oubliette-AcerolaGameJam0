extends MeshInstance3D
class_name AberrationScore
@onready var scoreDisplay = $SubViewport/Label

var isTrapDoorViewTweening : bool = false

var aberrationScore : int

		
func setAberrationScore(value : int):
		print("aberration score changed")
		aberrationScore = value
		scoreDisplay.text = str(0)
		light()
		
		AudioManager.PlaySound(AudioLibrary.newAberrationScore, 1.0, 0.0, 0.1, 0.0, self)
		for i in range(0,3):
			var tween2 = get_tree().create_tween()
			tween2.tween_property(scoreDisplay, "theme_override_font_sizes/font_size", 100, 0.05)
			tween2.tween_interval(0.1)
			scoreDisplay.text = str(floor(aberrationScore/(3-i)))
			prints(i,scoreDisplay.text)
			tween2.tween_property(scoreDisplay, "theme_override_font_sizes/font_size", 300, 0.1)
			await get_tree().create_timer(0.5).timeout
			
		await get_tree().create_timer(0.5).timeout
		animationFinished()

func decrementAberrationScore():
	for i in range(0, GameManager.playerScore):
		var tween2 = get_tree().create_tween()
		tween2.tween_property(scoreDisplay, "theme_override_font_sizes/font_size", 100, 0.01)
		AudioManager.PlaySound(AudioLibrary.scoreCount, 1.0, 0.0, 0.5, 0.0, self)	
		tween2.tween_interval(0.01)
		aberrationScore -= 1
		GameManager.playerScore -= 1
		SignalBus.updateScore.emit()
		scoreDisplay.text = str(aberrationScore)
		tween2.tween_property(scoreDisplay, "theme_override_font_sizes/font_size", 300, 0.05)
		await tween2.finished
		print("score count finished")
		if aberrationScore == 0:
			extinguish()
			return
	
		
	
func emitScoreCountFinished():
	SignalBus.scoreCountFinished.emit()
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
	
func animationFinished():
	SignalBus.AberrationAnimationComplete.emit()
	
func extinguish():
	visible = false
	#animate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
