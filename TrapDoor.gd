extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.aberrationCamera = $TrapDoorViewCam


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_trap_door_view_cam_tween_completed():
	print("emitting trap door move")
	SignalBus.trapDoorViewTweenComplete.emit()


func _on_trap_door_view_cam_tween_started():
	print("tween started")
	SignalBus.trapDoorViewTweenStarted.emit()
	
