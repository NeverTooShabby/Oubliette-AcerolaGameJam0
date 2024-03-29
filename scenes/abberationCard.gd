extends Card
class_name AberrationCard

@onready var cardStock = $cardStock


func _ready():
	sway_t = 0.0

	swayVertAmp = 0.01
	swayRotAmp = 0.01
	swayVertFreq = 0.2
	swayRotFreq = 0.5

	#TODO - put these somewhere else. If the card is index 0 it should come from the left. If it is index 1 it should come from the right
	offScreenPos = Vector3(4.0, -3.0, 0.0)
	offScreenRot = Vector3(0.0, PI/2, 0.0)

	cardPlayedHeight = 0.5
	cardPlayedRot = 4*PI

	lerpSpeed = 20.0
	
	var stockIndex = randi_range(0, CardDataLibrary.aberrationStocks.size() - 1)
	cardStock.mesh.material.albedo_texture = load(CardDataLibrary.aberrationStocks[stockIndex][0])
	cardStock.mesh.material.normal_texture = load(CardDataLibrary.aberrationStocks[stockIndex][1])
	
	cardStock.rotation.z = randi_range(0,3) * PI/2
	
var aberrationCardData : AberrationCardData:
	set(value):
		aberrationCardData = value
		var card_face = $Front
		var card_template = $Front/SubViewport/AberrationTemplate
		
		
		card_template.get_node("Title").text = aberrationCardData.AberrationName
		card_template.get_node("CardText/Condition").text = aberrationCardData.EffectText
		card_template.get_node("TargetValue").text = str(aberrationCardData.targetValue)
		
func play(): #overloads base function to do animations differently and shiiiiiit
	targetPosition.z += cardPlayedHeight
	#dissolve shader animation
	curState = State.PLAY
		
func setOffscreenPos(index : int):
	var posMult : int = 1
	
	if index == 0:
		posMult = -1
		
	offScreenPos = Vector3(0, 3.0 * posMult, 0.0)
	offScreenRot = Vector3(0.0, -1 * posMult * PI/2, 0.0)


