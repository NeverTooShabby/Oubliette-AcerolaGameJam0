extends CanvasLayer
@onready var label : Label = $Control/Instructions
@onready var player_score = $Control/PlayerScore
@onready var player_score_label = $Control/PlayerScoreLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.switchedToFieldView.connect(_fieldView)
	SignalBus.switchedToHandView.connect(_handView)
	
	#incedible jank
	SignalBus.switchedToOtherState.connect(hideSomeText)
	SignalBus.updateScore.connect(updateScore)

func setVisibility():
	if GameManager.state == GameManager.GameState.INTRO:
		hide()
	elif GameManager.state == GameManager.GameState.GAMEOVER:
		hide()
	else:
		show()
func hideSomeText():
	setVisibility()
		
	label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateScore():
	setVisibility()
	
	player_score.text = str(GameManager.playerScore)

func _handView():
	setVisibility()
	
	show()
	label.show()
	label.text = "Press E to Finish"
	
func _fieldView():
	setVisibility()
	
	show()
	label.show()
	label.text = "Press E to Return To Hand"
