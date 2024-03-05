extends Node3D
class_name Card

enum State {DEAL, FLOAT, SELECTED, MOVE, PLAY}
var curState : State

var sway_t : float = 0.0

var swayVertAmp : float = 0.01
var swayRotAmp : float = 0.01
var swayVertFreq : float = 0.2
var swayRotFreq : float = 0.5

var offScreenPos : Vector3 = Vector3(4.0, -3.0, 0.0)
var offScreenRot : Vector3 = Vector3(0.0, 0.0, -2*PI/3)

var cardPlayedHeight : float = 0.5
var cardPlayedRot : float = 4*PI

var lerpSpeed : float = 20.0

var targetPosition : Vector3
var targetRotation : Vector3

var data : CardData:
	set(value):
		var card_face = $Front
		var card_template = $Front/SubViewport/CardTemplate
		
		data = value
		
		card_template.get_node("Title").text = data.cardName
		card_template.get_node("CardText/Text").text = data.cardDescription
		card_template.get_node("Art").texture = data.art
		card_template.get_node("Art").modulate = GameManager.ColorFromCardDataEnum(data.cardColor)
#apparently should delete viewport after instantiating to save resources. Probably won't be needed

var PlaceableObject : Placeable

var cardType 
var cardImage #derived from held object
var cardColor

var selectedHeight : float = 0.5

func deal():
	curState = State.DEAL
	#TODO this should be controlled by global position of a 3d node in hand, passed via parameter
	position = offScreenPos #refNode.global_position - global_position
	rotation = offScreenRot 
	targetPosition = Vector3.ZERO
	targetRotation = Vector3.ZERO
	
func play():
	targetPosition.y = cardPlayedHeight
	targetRotation.y = cardPlayedRot
	curState = State.PLAY
	
func sway(delta):
	sway_t += delta * 2 * PI
	targetPosition.x = swayVertAmp * sin(swayVertFreq * sway_t)
	targetRotation.y = swayRotAmp * sin(swayRotFreq * sway_t)

func _physics_process(delta):
	position = position.lerp(targetPosition, lerpSpeed * delta)
	rotation = rotation.lerp(targetRotation, lerpSpeed * delta)
	
	match curState:
		State.DEAL:
			if moveComplete():
				SignalBus.CardDelt.emit()
		State.FLOAT:
			sway(delta)
		State.MOVE:
			moveComplete()
			SignalBus.CardMoveComplete.emit() #this will proc for all of the cards, only should be last, but they all move together. inefficient but not a real problem
		State.PLAY:
			if moveComplete():
				SignalBus.CardPlayAnimationComplete.emit()
	
func moveComplete() -> bool:
	var checkMove : bool = position.is_equal_approx(targetPosition) and rotation.is_equal_approx(targetRotation)
	if checkMove:
		curState = State.FLOAT
		sway_t = 0.0
	
	return checkMove
