extends Node

func _jouer() -> void:
	self.visible = false

func _afficherCrédits() -> void:
	if get_node("Credits").visible == false:
		get_node("Credits").visible = true
	else:
		get_node("Credits").visible = false

func _quitter() -> void:
	get_tree().quit()
