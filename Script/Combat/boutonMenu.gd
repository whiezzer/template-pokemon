extends MenuButton

var menuAttaque : Panel

var menuObjet : Panel

func _ready() -> void:
	menuAttaque = get_parent().get_node("MenuAttaque")
	menuObjet = get_parent().get_node("MenuObjet")

func _on_button_pressed() -> void:
	if menuAttaque.visible:
		menuAttaque.visible = false
		menuObjet.visible = true
	else:
		menuAttaque.visible = true
		menuObjet.visible = false
