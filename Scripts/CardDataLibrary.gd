extends Node

#this is should probably be a resource. But I don't know how to set it up good, do I?

var cardDataList : Array = ["res://objects/placeables/OneBlock.tres"]#,
							#"res://objects/placeables/TwoBlock.tres"]

#feels like these need to be a dict, but I'm charging ahead with an array and can change later
#aberration effect
var posEffects : Array = ["COLOR sigils worth 2x", "X tile sigils worth 2x", "+1 bonus sigil card per hand"]
var negEffects : Array = ["COLOR sigils worth 1/2", "X tile sigils worth 1/2", "Only deals X tiles"]
