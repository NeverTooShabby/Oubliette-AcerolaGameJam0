extends Control

@onready var master_slider = $Panel/VBoxContainer/MasterSlider
@onready var music_slider = $Panel/VBoxContainer/MusicSlider
@onready var sound_slider = $Panel/VBoxContainer/SoundSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	GameManager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)
	master_slider.value = 100
	music_slider.value = 100
	sound_slider.value = 100
	
func _on_game_manager_toggle_game_paused(isPaused : bool):
	if(isPaused):
		print("showing pause menu")
		show()
	else:
		print("hiding pause menu")		
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_button_down():
	GameManager.game_paused = false


func _on_quit_button_down():
	get_tree().quit()

func _on_master_slider_value_changed(value : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), AudioManager.PercentToDb(value))


func _on_music_slider_value_changed(value : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), AudioManager.PercentToDb(value))


func _on_sound_slider_value_changed(value : float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), AudioManager.PercentToDb(value))
