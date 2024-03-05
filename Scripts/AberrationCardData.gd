extends Resource
class_name AberrationCardData


var AberrationName : String
var targetValue : int #rand_range(some values scaled to the current level) +/- modifier for positive or negative effect

#need a dictionary of positive and negative effects. Holds description, referenced 
var isEffectPositive : bool
var EffectIndex : int
var EffectText : String
