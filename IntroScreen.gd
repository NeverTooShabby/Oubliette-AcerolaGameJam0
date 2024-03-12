extends AnimatedGraphic
@onready var title : Label = $Title
@onready var press_space : Label = $PressSpace


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.IntroAnimStart.connect(_startAnimation)
	turnOff()

func resetGraphics():
	title.set("theme_override_colors/font_color", Color(1,1,1,0))
	title.set("theme_override_colors/font_outline_color", Color(0,0,0,0))
	
	press_space.set("theme_override_colors/font_color", Color(1,1,1,0))
	
func _input(event):
	if event.is_action_pressed("select"):
		turnOff()
		GameManager.newScore()
		
	
func turnOff():
	set_process_input(false)
	hide()
	
func nextGameState():
	GameManager.toggleState(GameManager.GameState.HANDVIEW)

	
func turnOn():
	resetGraphics()
	show()

	var tween2 = get_tree().create_tween()
	tween2.tween_interval(1)
	tween2.parallel().tween_property(title, "theme_override_colors/font_color", Color(1, 1, 1, 1), 2)
	tween2.parallel().tween_property(title, "theme_override_colors/font_outline_color", Color(0, 0, 0, 1), 2)
	
	
	
	await get_tree().create_timer(2).timeout
	set_process_input(true)
	
	var tween3 = get_tree().create_tween()
	tween3.tween_property(press_space, "theme_override_colors/font_color", Color(1, 1, 1, 1), 1)
	await tween3.finished
