extends Node

const gridSize: float = 1.0 #size of boxes making up field grid

func PlaceablePlaced(placed : Placeable, placedField : Field, fieldSlots : Array):
	#field slots is an array of fieldslots for playing effects
	placed.placementColor(false)
	placed.reparent(placedField)
	#reparent to field, play effects
	pass
