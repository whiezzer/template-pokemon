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
		get_tree().current_scene.get_node("Joueur").dialogue = false
		get_tree().current_scene.get_node("Joueur").pause = false
	else:
		get_tree().current_scene.get_node("InterfaceTutoriel").visible = true
		get_tree().current_scene.get_node("Joueur").dialogue = true
		get_tree().current_scene.get_node("Joueur").pause = true

func _on_bouton_tuto_pressed(chemin: String) -> void:
	if get_tree().current_scene.get_node(chemin).visible:
		get_tree().current_scene.get_node(chemin).visible = false
	else:
		get_tree().current_scene.get_node(chemin).visible = true
