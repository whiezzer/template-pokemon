extends Node

var menuObjet : Panel
var menuPokemon : Panel

func _ready() -> void:
	menuObjet = get_tree().current_scene.get_node("InterfaceMenu/MenuObjet")
	menuPokemon = get_tree().current_scene.get_node("InterfaceMenu/MenuPokemon")

func _on_menu_objet_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	if menuObjet.visible == false:
		menuObjet.visible = true
	else:
		menuObjet.visible = false

func _on_menu_pokemon_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	if menuPokemon.visible == false:
		menuPokemon.visible = true
	else:
		menuPokemon.visible = false
