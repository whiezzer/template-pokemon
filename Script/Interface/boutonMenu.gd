extends Node

func _on_menu_objet_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	ecran_de_transition._fondu("InterfaceMenu/MenuObjet")

func _on_menu_pokemon_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	ecran_de_transition._fondu("InterfaceMenu/MenuPokemon")
