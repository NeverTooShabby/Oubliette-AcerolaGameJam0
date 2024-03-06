extends CanvasLayer
@onready var splatters : ColorRect = $Splatters
@onready var game_over : Label = $GameOver
@onready var press_space : Label = $PressSpace
@onready var blood_splatter_1 : Sprite2D = $"Splatters/Blood-splatter-png-44464"
@onready var blood_splatter_2 : Sprite2D = $"Splatters/Blood-splatter-png-44466"
@onready var bg_color : ColorRect = $BgColor


# Called when the node enters the scene tree for the first time.
func _ready():
	turnOff()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func turnOff():
	bg_color.color = Color(0.333333, 0.0627451, 0, 0)
	blood_splatter_1.visible = false
	blood_splatter_2.visible = false
	game_over.set("theme_override_colors/font_color", Color(1,1,1,0))
	press_space.set("theme_override_colors/font_color", Color(1,1,1,0))
	
	hide()
	
func turnOn():
	show()
	var tween = get_tree().create_tween()
	tween.tween_property(bg_color, "color", Color(0.333333, 0.0627451, 0, 1), 0.5)
	await tween.finished
	
	await get_tree().create_timer(0.5).timeout
	blood_splatter_1.visible = true
	#TODO play splat sound
	await get_tree().create_timer(0.7).timeout
	blood_splatter_2.visible = true
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(game_over, "theme_override_colors/font_color", Color(1, 1, 1, 1), 2)
	
	await get_tree().create_timer(1).timeout
	
	var tween3 = get_tree().create_tween()
	tween3.tween_property(press_space, "theme_override_colors/font_color", Color(1, 1, 1, 1), 1)
	await tween3.finished
	
	

