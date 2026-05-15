extends TextureButton

var objet : ObjetInventaire

var combat : Node3D

var menuAttaque : Control

var menuObjet : Control

var textureObjet = TextureRect

var objetDescription : Label

var objetNom : Label

func _ready() -> void:
	combat = get_parent().get_parent().get_parent()
	menuAttaque = get_parent().get_parent().get_parent().get_node("InterfaceCombat")
	menuObjet = get_parent().get_parent().get_parent().get_node("InterfaceSac")
	objetDescription = get_parent().get_parent().get_node("Label_Description")
	textureObjet = get_parent().get_parent().get_node("TextureRect_Objet")

func _physics_process(delta: float) -> void:
	objetNom.text = objet.objet.nom + " : " + str(objet.quantite)

func _on_button_pressed() -> void:
	if objet == null || objet.quantite == 0 || combat.tourDuJoueur == false || combat.enCoursDeTour == true:
		return
	
	if menuAttaque.visible:
		menuAttaque.visible = false
		menuObjet.visible = true
	else:
		menuAttaque.visible = true
		menuObjet.visible = false
	
	objet.quantite -= 1
	combat.enCoursDeTour = true
	
	combat.ecrire_texte(combat.message, "Vous utilisez un " + objet.objet.nom)
	await get_tree().create_timer(2.0).timeout
	
	if objet.objet.capture == true:
		combat.ecrire_texte(combat.message, "Vous tentez de capturer un " + dataDuJeu.pokemonEnnemiStats.nom + " sauvage")
		await _capture()
	elif objet.objet.reanime == true:
		combat.ecrire_texte(combat.message, "Vous reanimez " + dataDuJeu.pokemonJoueurStats.nom)
	elif objet.objet.soigne == true:
		combat.ecrire_texte(combat.message, "Vous soignez " + dataDuJeu.pokemonJoueurStats.nom + " de " + str(dataDuJeu.pokemonJoueurStats.pv * int(objet.objet.nbPvSoigne.substr(0, objet.objet.nbPvSoigne.length() - 1)) / 100) + " points de vies")
		dataDuJeu.pokemonJoueurStats.pv_Actuels += dataDuJeu.pokemonJoueurStats.pv * int(objet.objet.nbPvSoigne.substr(0, objet.objet.nbPvSoigne.length() - 1)) / 100
		if dataDuJeu.pokemonJoueurStats.pv_Actuels > dataDuJeu.pokemonJoueurStats.pv:
			dataDuJeu.pokemonJoueurStats.pv_Actuels = dataDuJeu.pokemonJoueurStats.pv
	
	if combat.enCoursDeTour == true:
		await get_tree().create_timer(2.0).timeout
		
		combat.enCoursDeTour = false
		combat.tourDuJoueur = false
		
		await combat._tourAdverse()
		
		combat.tourDuJoueur = true
		combat.ecrire_texte(combat.message, "Choisissez une action")

func _on_mouse_entered() -> void:
	objetDescription.text = objet.objet.description
	textureObjet.texture = objet.objet.texture

func _capture() -> void:
	
	var resultat = randf() * (100.0 * (dataDuJeu.pokemonEnnemiStats.pv_Actuels / dataDuJeu.pokemonEnnemiStats.pv * 1))
	
	get_tree().current_scene.get_node_or_null("PokemonEnnemi/AnimatedSpriteAttaque").play("Pokeball")
	get_tree().current_scene.get_node_or_null("PokemonEnnemi/Sprite3D").visible = false
	
	if resultat <= 10.0:
		
		await get_tree().current_scene.get_node_or_null("PokemonEnnemi/AnimatedSpriteAttaque").animation_finished
		
		combat.ecrire_texte(combat.message, "Bravo ! Vous avez attrapé un " + dataDuJeu.pokemonEnnemiStats.nom + " sauvage")
		
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
		
		dataDuJeu.listePokemonsJoueur.append(dataDuJeu.pokemonEnnemiStats.duplicate(true))
		
		dataDuJeu.listePokemonsEnnemie.clear()
		
		combat.enCoursDeTour = false
		
		get_tree().change_scene_to_file("res://Scene/ScenePrincipale.tscn")
		
	else:
		
		await get_tree().create_timer(3.0).timeout
		
		get_tree().current_scene.get_node_or_null("PokemonEnnemi/AnimatedSpriteAttaque").play("Pokeball_casser")
		
		get_tree().current_scene.get_node_or_null("PokemonEnnemi/Sprite3D").visible = true
		
		await get_tree().current_scene.get_node_or_null("PokemonEnnemi/AnimatedSpriteAttaque").animation_finished
		
		combat.ecrire_texte(combat.message, "Ca a raté ..")
		
		await get_tree().create_timer(1.0).timeout
