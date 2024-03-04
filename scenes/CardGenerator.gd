extends Node
class_name CardGenerator
#probably store this in its own resource
var cardDataList : Array = ["res://objects/placeables/OneBlock.tres"]#,
							#"res://objects/placeables/TwoBlock.tres"]
							
#should take card type and weighting parameters. Maybe read weights from GameManager.
func GenerateCard():
	var randIndex = RandomizeCardType()
	var randColorIndex = RandomizeColor()
	
	#create varaible to store new cardData resource
	var newCardData : CardData = CardData.new()
	
	#load reference values. Do not alter this, it will alter globally
	var refValues : CardData = load(cardDataList[randIndex])
	
	#there's got to be a better way
	
	newCardData.art = refValues.art
	newCardData.cardColor = randColorIndex
	var colorString = ColorEnumString(newCardData.cardColor)
	newCardData.cardName = colorString + " " + refValues.cardName
	newCardData.baseValue = refValues.baseValue
	newCardData.placeableObjectResourcePath = refValues.placeableObjectResourcePath
	newCardData.cardDescription = refValues.cardDescription.replace("COLOR", colorString)
	return newCardData
	
func RandomizeCardType() -> int:
	print ()
	return randi_range(0, cardDataList.size() - 1)

func RandomizeColor () -> int:
	#tweaks to randomization can happen here
	return randi_range(0,CardData.CardColor.size()-1)
	
func ColorEnumString(enumVal : CardData.CardColor) -> String:
	match enumVal:
		CardData.CardColor.COLORLESS:
			return "Colorless"
		CardData.CardColor.RED:
			return "Red"
		CardData.CardColor.BLUE:
			return "Blue"
		CardData.CardColor.GREEN:
			return "Green"
	return "Aw Fuck, " + str(enumVal)
