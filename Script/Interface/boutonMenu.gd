extends Node

func _on_menu_objet_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	ecran_de_transition._fondu("InterfaceMenu/MenuObjet")

func _on_menu_pokemon_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	ecran_de_transition._fondu("InterfaceMenu/MenuPokemon")

func _afficherCrédits() -> void:
	if get_node("Credits").visible == false:
		get_node("Credits").visible = true
	else:
		get_node("Credits").visible = false

func _quitter() -> void:
	get_tree().quit()
