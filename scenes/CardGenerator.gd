extends Node
class_name CardGenerator
#probably store this in its own resource
var cardDataList = CardDataLibrary.cardDataList

var aberrationScale : int = 10
var startingTarget : int = 20
var negEffectMod : float = 0.8
#should take card type and weighting parameters. Maybe read weights from GameManager.

func GenerateAberration(isEffectPositive : bool) -> AberrationCardData:
	#I'm basically just using these resources as structs. Is that how they're supposed to work? I think I've done something goofy here.
	var newCardData : AberrationCardData = AberrationCardData.new()
	var effectMult : float
	
	newCardData.AberrationName  = GenerateAberrationName()
	newCardData.isEffectPositive = isEffectPositive

	if not isEffectPositive:
		effectMult = negEffectMod
		newCardData.EffectIndex = randi_range(0, CardDataLibrary.negEffects.size()-1)
		newCardData.EffectText =  CardDataLibrary.negEffects[newCardData.EffectIndex] #there's no reason to do this here instead of on the card, but I'm already here
	else:
		effectMult = 1
		newCardData.EffectIndex = randi_range(0, CardDataLibrary.posEffects.size()-1)
		newCardData.EffectText =  CardDataLibrary.posEffects[newCardData.EffectIndex]
		
	#can/should add randomness here
	newCardData.targetValue = floori(startingTarget + GameManager.aberrationNumber * aberrationScale  *  effectMult)
	
	return newCardData
	
func GenerateAberrationName() -> String:
	#put a silly little generator here with prefixes like cthon or arc or and suffics like ulu or athon or igula 
	return "Butt Soup" 
	
func GenerateCard() -> CardData:
	var randIndex = RandomizeCardType()
	var randColorIndex = RandomizeColor()
	
	#create varaible to store new cardData resource
	var newCardData : CardData = CardData.new()
	
	#load reference values. Do not alter the refValues card it will alter globally
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
