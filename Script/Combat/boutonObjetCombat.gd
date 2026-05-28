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
	if objet.objet.capture == true && dataDuJeu.listeGodomonsEnnemie != []:
		return
	
	if !menuObjet.visible:
		menuAttaque.visible = false
		menuObjet.visible = true
	else:
		menuAttaque.visible = true
		menuObjet.visible = false
	
	if objet.objet.capture == true:
		combat.ecrire_texte(combat.message, "Vous tentez de capturer un/une " + dataDuJeu.pokemonEnnemiStats.nom + " sauvage")
		await _capture()
	elif objet.objet.reanime == true:
		await _choixGodomon()
	elif objet.objet.soigne == true:
		await _choixGodomon()
	
	if combat.enCoursDeTour == true:
		await get_tree().create_timer(2.0).timeout
		
		combat.enCoursDeTour = false
		combat.tourDuJoueur = false
		
		await combat._tourAdverse()
		
		if !combat.finCombat:
			combat.tourDuJoueur = true
			combat.ecrire_texte(combat.message, "Choisissez une action")

func _on_mouse_entered() -> void:
	objetDescription.text = objet.objet.description
	textureObjet.texture = objet.objet.texture

func _capture() -> void:
	
	objet.quantite -= 1
	combat.enCoursDeTour = true
	
	var resultat = randf() * (100.0 * (float(dataDuJeu.pokemonEnnemiStats.pv_Actuels) / float(dataDuJeu.pokemonEnnemiStats.pv)))
	
	get_tree().current_scene.get_node_or_null("GodomonEnnemi/AnimatedSpriteAttaque").play("Pokeball")
	get_tree().current_scene.get_node_or_null("GodomonEnnemi/Sprite3D").visible = false
	
	if resultat <= 10.0:
		
		await get_tree().current_scene.get_node_or_null("GodomonEnnemi/AnimatedSpriteAttaque").animation_finished
		
		combat.ecrire_texte(combat.message, "Bravo ! Vous avez attrapé un/une " + dataDuJeu.pokemonEnnemiStats.nom + " sauvage")
		get_tree().current_scene.get_node("AudioMusique3D").stream = dataDuJeu.musiqueVictoire
		get_tree().current_scene.get_node("AudioMusique3D").play()
		
		combat.get_node("InterfaceCombat/AnimatedSprite2D").visible = true
		
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
		
		combat.get_node("InterfaceCombat/AnimatedSprite2D").visible = false
		
		var nouveauGodomon = dataDuJeu.pokemonEnnemiStats.duplicate(true)
		nouveauGodomon._listeDesTypes = dataDuJeu.listeDesTypes
		nouveauGodomon._type_index = dataDuJeu.pokemonEnnemiStats._type_index
		nouveauGodomon.nature = dataDuJeu.pokemonEnnemiStats.nature
		dataDuJeu.listeGodomonsJoueur.append(nouveauGodomon)
		
		dataDuJeu.listeGodomonsEnnemie.clear()
		
		combat.enCoursDeTour = false
		
		get_tree().change_scene_to_file("res://Scene/ScenePrincipale.tscn")
		
	else:
		
		await get_tree().create_timer(3.0).timeout
		
		get_tree().current_scene.get_node_or_null("GodomonEnnemi/AnimatedSpriteAttaque").play("Pokeball_casser")
		
		get_tree().current_scene.get_node_or_null("GodomonEnnemi/Sprite3D").visible = true
		
		await get_tree().current_scene.get_node_or_null("GodomonEnnemi/AnimatedSpriteAttaque").animation_finished
		
		combat.ecrire_texte(combat.message, "Ca a raté ..")
		
		await get_tree().create_timer(1.0).timeout

func _choixGodomon() -> void:
	await ecran_de_transition._fondu("InterfaceGodomon")
	dataDuJeu.objetUtilisé = objet
