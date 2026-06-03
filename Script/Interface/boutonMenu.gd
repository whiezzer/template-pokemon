extends Node

func _on_menu_objet_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	ecran_de_transition._fondu("InterfaceMenu/MenuObjet")

func _on_menu_pokemon_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	ecran_de_transition._fondu("InterfaceMenu/MenuGodomon")

func _quitter() -> void:
	
	get_tree().quit()

func _on_credit_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	ecran_de_transition._fondu("InterfaceMenu/Credit")

func _on_tuto_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	if get_tree().current_scene.get_node("InterfaceTutoriel").visible:
		get_tree().current_scene.get_node("InterfaceTutoriel").visible = false
	else:
		get_tree().current_scene.get_node("InterfaceTutoriel").visible = true
