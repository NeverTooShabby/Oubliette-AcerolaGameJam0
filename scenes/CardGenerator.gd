extends Node
class_name CardGenerator
#probably store this in its own resource
var cardDataList : Array = ["res://objects/placeables/OneBlock.tres",
							"res://objects/placeables/TwoBlock.tres"]
							
#should take card type and weighting parameters. Maybe read weights from GameManager.
func GenerateCard():
	var randIndex : int = randi_range(0, cardDataList.size() - 1)
	return load(cardDataList[randIndex])
