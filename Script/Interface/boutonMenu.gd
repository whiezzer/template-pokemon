extends Node

var menuObjet : Panel

func _ready() -> void:
	menuObjet = get_tree().current_scene.get_node("InterfaceMenu/MenuObjet")

func _on_button_pressed() -> void:
	if menuObjet.visible == false:
		menuObjet.visible = true
	else:
		menuObjet.visible = false
