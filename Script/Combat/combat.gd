extends Node

var pokemonJoueur : PokemonData

var pokemonEnnemi : PokemonData

var pvJoueurInterface : float

var pvEnnemiInterface : float

var pvVitesse : float = 2

var tourDuJoueur : bool

var message : RichTextLabel

var enCoursDeTour : bool = false

var finCombat : bool = false

# Fonction qui se lance avant toutes les autres
func _enter_tree() -> void:
	
	pokemonJoueur = dataDuJeu.pokemonJoueurStats
	pokemonEnnemi = PokemonData.new(randi() % dataDuJeu.listeDesTypes.size(), 7, 5, 3, 3)
	dataDuJeu.pokemonEnnemiStats = pokemonEnnemi 
	message = $InterfaceCombat/ZoneDeTexte
	
	_misAJourInterface()

# Fonction appellé au lancement du combat
func  _ready() -> void:
	
	_créerBoutonsMenuObjet()
	
	ecrire_texte(message, "Début du combat")
	
	if pokemonJoueur.vitesse >= pokemonEnnemi.vitesse:
		await get_tree().create_timer(2.0).timeout
		ecrire_texte(message, "Choisissez une action")
		tourDuJoueur = true
	else :
		tourDuJoueur = false
		await get_tree().create_timer(2.0).timeout
		_tourAdverse()

# Fonction appellé à chaque frame
func _physics_process(delta: float) -> void:
	
	if pvJoueurInterface > pokemonJoueur.pv_Actuels:
		pvJoueurInterface -= delta * pvVitesse
	if pvEnnemiInterface > pokemonEnnemi.pv_Actuels:
		pvEnnemiInterface -= delta * pvVitesse
	
	if pvJoueurInterface < pokemonJoueur.pv_Actuels:
		pvJoueurInterface = pokemonJoueur.pv_Actuels
	if pvEnnemiInterface < pokemonEnnemi.pv_Actuels:
		pvEnnemiInterface = pokemonEnnemi.pv_Actuels
	
	_misAJourInterface()

# Fonction qui gère le tour de l'adversaire
func _tourAdverse() -> void:
	if enCoursDeTour || finCombat:
		return
	
	var NbAttaqueUtilisable = 4
	
	for attaque in pokemonEnnemi.listeAttaque:
		if attaque.PP == 0:
			NbAttaqueUtilisable -=1
	
	var attaqueUtilse : Attaque
	
	if NbAttaqueUtilisable == 0:
		attaqueUtilse = Attaque.new("Charge", "Normal", 3, -10)
	else:
		attaqueUtilse = pokemonEnnemi.listeAttaque[randi() % 4]
		while attaqueUtilse.PP == 0:
			attaqueUtilse = pokemonEnnemi.listeAttaque[randi() % 4]
	
	enCoursDeTour = true
	
	var degatsInflige = int(ceil(attaqueUtilse.puissance * pokemonEnnemi.attaque / pokemonJoueur.defense))
	
	var efficaciteAttaque = ""
	
	if attaqueUtilse.type == pokemonJoueur.type.faiblesse:
		degatsInflige = int(ceil(degatsInflige * 1.5))
		efficaciteAttaque = "c'est [color=yellow]SUPER[/color] efficace"
	if attaqueUtilse.type == pokemonJoueur.type.resistance:
		degatsInflige = int(floor(degatsInflige * 0.5))
		efficaciteAttaque = "c'est [color=gray]pas très efficace[/color]"
	
	attaqueUtilse.PP -= 1
	
	ecrire_texte(message, "Le" + pokemonEnnemi.nom + " adverse utilise : " + attaqueUtilse.nom)
	
	$PokemonJoueur/AnimatedSpriteAttaque.play(attaqueUtilse.nom)
	
	if randf() <= attaqueUtilse.precision:
		pokemonJoueur.pv_Actuels -= degatsInflige
		
		while pvJoueurInterface != pokemonJoueur.pv_Actuels:
			await get_tree().process_frame
		
		if efficaciteAttaque != "":
			ecrire_texte(message, efficaciteAttaque)
	else:
		await get_tree().create_timer(1.0).timeout
		ecrire_texte(message, "Il rate !")
	
	await get_tree().create_timer(2.0).timeout
	
	ecrire_texte(message, "Choisissez une action")
	
	_finDeTour()
	
	if finCombat == false:
		
		enCoursDeTour = false
		tourDuJoueur = true

# Fonction qui gère le tour du joueur
func _tourJoueur(attaque : Attaque) -> void:
	if enCoursDeTour || finCombat:
		return
	
	var NbAttaqueUtilisable = 4
	
	if attaque.PP == 0:
		for att in pokemonJoueur.listeAttaque:
			if att.PP == 0:
				NbAttaqueUtilisable -=1
		
		if NbAttaqueUtilisable == 0:
			attaque = Attaque.new("Charge", "Normal", 3, -10)
		else:
			return
	
	enCoursDeTour = true
	
	var degatsInflige = int(ceil(attaque.puissance * pokemonJoueur.attaque / pokemonEnnemi.defense))
	
	var efficaciteAttaque = ""
	
	if attaque.type == pokemonEnnemi.type.faiblesse:
		degatsInflige = int(ceil(degatsInflige * 1.5))
		efficaciteAttaque = "c'est [color=yellow]SUPER[/color] efficace !"
	if attaque.type == pokemonEnnemi.type.resistance:
		degatsInflige = int(floor(degatsInflige * 0.5))
		efficaciteAttaque = "c'est [color=gray]pas très efficace..[/color]"
	
	attaque.PP -= 1
	
	ecrire_texte(message, pokemonJoueur.nom + " utilise : " + attaque.nom)
	
	$PokemonEnnemi/AnimatedSpriteAttaque.play(attaque.nom)
	
	if randf() <= attaque.precision:
		pokemonEnnemi.pv_Actuels -= degatsInflige
		
		while pvEnnemiInterface != pokemonEnnemi.pv_Actuels:
			await get_tree().process_frame
		
		if efficaciteAttaque != "":
			ecrire_texte(message, efficaciteAttaque)
	else:
		await get_tree().create_timer(1.0).timeout
		ecrire_texte(message, "Il rate..")
	
	await get_tree().create_timer(2.0).timeout
	
	_finDeTour()
	
	if finCombat == false:
		
		enCoursDeTour = false
		tourDuJoueur = false
		
		await _tourAdverse()

# Fonction qui vérifie si le combat est terminé ou pas après le tour d'un combattant
func _finDeTour() -> void :
	
	if pokemonEnnemi.pv_Actuels <= 0:
		
		finCombat = true
		ecrire_texte(message, "[color=blue]Victoire ![/color]")
		
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
		
		while Input.is_action_pressed("ui_accept"):
			await get_tree().process_frame
		
		pokemonJoueur.xp += 250 * pokemonEnnemi.lvl
		
		ecrire_texte(message, pokemonJoueur.nom + " gagne " + "[color=blue]" + str(250 * pokemonEnnemi.lvl) + "[/color]" + " points de niveaux")
		
		_misAJourInterface()
		
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
		
		get_tree().change_scene_to_file("res://Scene/ScenePrincipale.tscn")
		
	elif pokemonJoueur.pv_Actuels <= 0:
		
		finCombat = true
		ecrire_texte(message, "[color=red]Défaite[/color]")
		
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
		
		pokemonJoueur.pv_Actuels = pokemonJoueur.pv
		get_tree().change_scene_to_file("res://Scene/ScenePrincipale.tscn")

# Fonction qui met à jour l'interface
func _misAJourInterface():
	$InterfaceCombat/InterfaceInfoPokemon2/PV.value = pvEnnemiInterface
	$InterfaceCombat/InterfaceInfoPokemon2/PV.max_value = pokemonEnnemi.pv
	
	$InterfaceCombat/InterfaceInfoPokemon1/PV.value = pvJoueurInterface
	$InterfaceCombat/InterfaceInfoPokemon1/PV.max_value = pokemonJoueur.pv
	
	$InterfaceCombat/InterfaceInfoPokemon1/LVL.value = pokemonJoueur.xp
	$InterfaceCombat/InterfaceInfoPokemon1/LVL.max_value = pokemonJoueur.xpObjectif
	$InterfaceCombat/InterfaceInfoPokemon1/LVL/Texte_Niveau.text = str(pokemonJoueur.xp) + "/" + str(pokemonJoueur.xpObjectif)
	
	$InterfaceCombat/InterfaceInfoPokemon2/Texte_Nom.text = pokemonEnnemi.nom
	$InterfaceCombat/InterfaceInfoPokemon1/Texte_Nom.text = pokemonJoueur.nom
	
	$InterfaceCombat/InterfaceInfoPokemon2/Texte_Level.text = str(pokemonEnnemi.lvl)
	$InterfaceCombat/InterfaceInfoPokemon1/Texte_Level.text = str(pokemonJoueur.lvl)
	
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque1".text = pokemonJoueur.listeAttaque[0].nom + "\n" + "\n            PP : " + str(pokemonJoueur.listeAttaque[0].PP) + "/" + str(pokemonJoueur.listeAttaque[0].PP_max)
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque2".text = pokemonJoueur.listeAttaque[1].nom + "\n" + "\n            PP : " + str(pokemonJoueur.listeAttaque[1].PP) + "/" + str(pokemonJoueur.listeAttaque[1].PP_max)
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque3".text = pokemonJoueur.listeAttaque[2].nom + "\n" + "\n            PP : " + str(pokemonJoueur.listeAttaque[2].PP) + "/" + str(pokemonJoueur.listeAttaque[2].PP_max)
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque4".text = pokemonJoueur.listeAttaque[3].nom + "\n" + "\n            PP : " + str(pokemonJoueur.listeAttaque[3].PP) + "/" + str(pokemonJoueur.listeAttaque[3].PP_max)
	
	for i in range(1, pokemonJoueur.listeAttaque.size()+1):
		get_node("InterfaceCombat/MenuAttaque/Bouton-Attaque" + str(i) + "/TextureRect").texture = load("res://Assets/Interface/Type/" + pokemonJoueur.listeAttaque[i-1].type + ".png")

# Fonction qui un text petit à petit
func ecrire_texte(label: RichTextLabel, texte: String, vitesse := 0.03):
	label.text = texte
	label.visible_characters = 0
	
	while label.visible_characters < texte.length():
		label.visible_characters += 1
		await get_tree().create_timer(vitesse).timeout

# Fonction qui crée des boutons d'objets dans le menu objets par rapport au nombre d'objets dans la ListeDesObjets
func _créerBoutonsMenuObjet() -> void:
	var positionBoutonObjets = Vector2(77.0, 50.0)
	
	for objet in dataDuJeu.listeDesObjets:
		
		var bouton = Button.new()
		bouton.set_script(preload("res://Script/Combat/boutonObjet.gd"))
		
		$InterfaceCombat/MenuObjet.add_child(bouton)
		
		bouton.objet = objet
		bouton.position = positionBoutonObjets
		bouton.size = Vector2(199.0, 25.0)
		bouton.add_theme_font_override("font", preload("res://Assets/Text/pixel_operator/PixelOperator.ttf"))
		bouton.add_theme_font_size_override("font_size", 20)
		bouton.pressed.connect(bouton._on_button_pressed)
		
		positionBoutonObjets.y += 50.0
