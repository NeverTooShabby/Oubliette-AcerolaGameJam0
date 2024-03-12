extends CanvasLayer
@onready var label : Label = $Control/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.switchedToFieldView.connect(_fieldView)
	SignalBus.switchedToHandView.connect(_handView)
	
	#incedible jank
	SignalBus.switchedToOtherState.connect(hide)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _handView():
	show()
	label.text = "Press E to Finish"
	
func _fieldView():
	show()
	label.text = "Press E to Return To Hand"
