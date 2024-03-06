extends CanvasLayer
class_name AnimatedGraphic

func turnOff():
	set_process_input(false)
	hide()
	
func nextGameState():
	#virtual function
	pass
	
func resetGraphics():
	#virtual function not sure if I need this one
	pass
	
func _startAnimation():
	turnOn()
	
func _input(event):
	if event.is_action_pressed("select"):
		turnOff()
		nextGameState()
		
func turnOn():
	#deffo need this virtual function. Could call show here but what's the point?
	pass
