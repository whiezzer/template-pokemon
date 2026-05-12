extends TextureButton

var menuAttaque : Control

var menuObjet : Control

var combat : Node3D

func _ready() -> void:
	menuAttaque = get_parent().get_parent().get_node("InterfaceCombat")
	menuObjet = get_parent().get_parent().get_node("InterfaceSac")
	combat = get_parent().get_parent()

func _on_button_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	if combat.tourDuJoueur == true && combat.enCoursDeTour == false:
		if menuAttaque.visible:
			menuAttaque.visible = false
			menuObjet.visible = true
		else:
			menuAttaque.visible = true
			menuObjet.visible = false
