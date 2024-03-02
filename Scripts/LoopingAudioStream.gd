extends Node
class_name LoopingAudioStream

var stream : AudioStream
var elapsedTime : float = 0.0
var overlap : float = 0
var length : float = 0
var playNextTime : float = 0


func setStream(newStream : AudioStream, newReverbTail : float = 0):
	stream = newStream
	overlap = newReverbTail
	length = stream.get_length()
	playNextTime = length - overlap
	makeAMPlay()
	
	
func makeAMPlay():
	AudioManager.PlaySound(stream, 1.0, 0.0, 1.0, 0.0, self)
	
func _process(delta):
	elapsedTime += delta
	if elapsedTime > playNextTime:
		elapsedTime = 0
		makeAMPlay()
	pass
