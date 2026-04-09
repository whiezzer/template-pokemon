extends Node

var combat: Combat

func  _ready() -> void:
	combat = Combat.new()
	add_child(combat)
	combat._combat()
