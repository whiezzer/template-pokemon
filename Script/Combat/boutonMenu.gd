extends MenuButton

var menuAttaque : Control

var menuObjet : Control

func _ready() -> void:
	menuAttaque = get_parent().get_parent().get_node("InterfaceCombat")
	menuObjet = get_parent().get_parent().get_node("InterfaceSac")

func _on_button_pressed() -> void:
	if menuAttaque.visible:
		menuAttaque.visible = false
		menuObjet.visible = true
	else:
		menuAttaque.visible = true
		menuObjet.visible = false
