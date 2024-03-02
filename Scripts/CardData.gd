extends Resource

class_name CardData

enum CardType {PIECE, TYPE}
enum CardColor {COLORLESS, RED, BLUE, GREEN}


@export var cardType : CardType
@export var cardName : String
@export var cardColor : CardColor
@export_multiline var cardDescription : String
@export var art : Texture
@export var baseValue : int
