extends TextureButton

var menuAttaque : Control

var menuObjet : Control

var menuPokemon : Control

var combat : Node3D

func _ready() -> void:
	menuAttaque = get_parent().get_parent().get_node("InterfaceCombat")
	menuObjet = get_parent().get_parent().get_node("InterfaceSac")
	menuPokemon = get_tree().current_scene.get_node("InterfacePokemon")
	combat = get_parent().get_parent()

func _on_menu_objet_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	if combat.tourDuJoueur == true && combat.enCoursDeTour == false:
		if menuAttaque.visible:
			menuAttaque.visible = false
			menuObjet.visible = true
		else:
			menuAttaque.visible = true
			menuObjet.visible = false

func _on_menu_pokemon_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	if combat.tourDuJoueur == true && combat.enCoursDeTour == false:
		if menuAttaque.visible:
			menuAttaque.visible = false
			menuPokemon.visible = true
		else:
			menuAttaque.visible = true
			menuPokemon.visible = false
