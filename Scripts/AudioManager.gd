extends Node

var effectsVolume : float = 1.0

func PlaySound(stream : AudioStream, pitchScale : float = 1.0, pitchVariance : float = 0.0, volScalePercent : float = 1.0, volVariancePercent : float = 0.0, calledBy : Object = self, AudioBusName : String = "Master"):
	if (volScalePercent > 0): #idk what kind of asshole would try to play sound with vol scale = 0, but there you go. Might want to change this if other code needs to know about the sound playing
		var soundInstance : AudioStreamPlayer = AudioStreamPlayer.new()
		soundInstance.bus = AudioBusName
		soundInstance.stream = stream
		var volScaleDb : float = PercentToDb(effectsVolume * volScalePercent)
		var volVarianceDb : float
		if volVariancePercent == 0.0:
			volVarianceDb = 0.0
		else:
			volVarianceDb = PercentToDb(1- (effectsVolume * volVariancePercent))
		soundInstance.volume_db = randf_range(volScaleDb - abs(volVarianceDb), volScaleDb + abs(volVarianceDb))
		soundInstance.pitch_scale = randf_range(pitchScale - pitchVariance, pitchScale + pitchVariance)
		soundInstance.finished.connect(RemoveNode.bind(soundInstance))
		add_child(soundInstance)
		soundInstance.play()
		
		#reparent so if the calledBy object is deleted, the sound stops
		if calledBy != self:
			soundInstance.reparent(calledBy)
		
#TODO queue these for music playback. Removenode is used for axing.
func PlayLoop(stream : AudioStream, reverbTail : float = 0.0): #TODO implement same scaling features as PlaySound
	var loopingAudio : LoopingAudioStream = LoopingAudioStream.new()
	loopingAudio.setStream(stream, reverbTail)
	add_child(loopingAudio)
	return loopingAudio
	
func RemoveNode(soundInstance):
	soundInstance.queue_free()
	
func PercentToDb(percentVal : float)-> float: 
	var dBVal : float = 10 * log(percentVal)/log(10)
	return dBVal
