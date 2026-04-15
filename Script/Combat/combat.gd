extends Node

var pokemonJoueur : PokemonData

var pokemonEnnemi : PokemonData

var pvJoueurInterface : float

var pvEnnemiInterface : float

var pvVitesse : float = 2

var tourDuJoueur : bool

var message : Label

var enCoursDeTour : bool = false

var finCombat : bool = false

# Fonction qui se lance avant toutes les autres
func _enter_tree() -> void:
	
	var types = ["Feu", "Plante", "Eau"]
	
	pokemonJoueur = dataDuJeu.pokemonJoueurStats
	pokemonEnnemi = PokemonData.new(types[randi() % types.size()], 7, 5, 3, 3)
	dataDuJeu.pokemonEnnemiStats = pokemonEnnemi 
	message = $InterfaceCombat/ZoneDeTexte2
	
	if pokemonJoueur.lvl > 1:
		for lvl in range (2, pokemonJoueur.lvl + 1 + randi_range(-1, 1)):
			pokemonEnnemi._niveauSuperieur()
	
	_misAJourInterface()

# Fonction appellé au lancement du combat
func  _ready() -> void:
	
	ecrire_texte(message, "Début du combat")
	
	if pokemonJoueur.vitesse >= pokemonEnnemi.vitesse:
		await get_tree().create_timer(0.5).timeout
		ecrire_texte(message, "Choisissez une action")
		tourDuJoueur = true
	else :
		tourDuJoueur = false
		await get_tree().create_timer(2.0).timeout
		_tourAdverse()

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
	
	if attaqueUtilse.type == pokemonJoueur.faiblesse:
		degatsInflige = int(ceil(degatsInflige * 1.5))
		efficaciteAttaque = "c'est SUPER efficace"
	if attaqueUtilse.type == pokemonJoueur.resistance:
		degatsInflige = int(floor(degatsInflige * 0.5))
		efficaciteAttaque = "c'est pas très efficace"
	
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
	
	if attaque.type == pokemonEnnemi.faiblesse:
		degatsInflige = int(ceil(degatsInflige * 1.5))
		efficaciteAttaque = "c'est SUPER efficace !"
	if attaque.type == pokemonEnnemi.resistance:
		degatsInflige = int(floor(degatsInflige * 0.5))
		efficaciteAttaque = "c'est pas très efficace.."
	
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
		ecrire_texte(message, "Victoire")
		
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
		
		while Input.is_action_pressed("ui_accept"):
			await get_tree().process_frame
		
		pokemonJoueur.xp += 250 * pokemonEnnemi.lvl
		
		ecrire_texte(message, pokemonJoueur.nom + " gagne " + str(250 * pokemonEnnemi.lvl) + " points de niveaux")
		
		_misAJourInterface()
		
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
		
		get_tree().change_scene_to_file("res://Scene/ScenePrincipale.tscn")
		
	elif pokemonJoueur.pv_Actuels <= 0:
		
		finCombat = true
		ecrire_texte(message, "Défaite")
		
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
	
	$InterfaceCombat/InterfaceInfoPokemon2/Texte_Level.text = "nv : " + str(pokemonEnnemi.lvl)
	$InterfaceCombat/InterfaceInfoPokemon1/Texte_Level.text = "nv : " + str(pokemonJoueur.lvl)
	
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque1".text = pokemonJoueur.listeAttaque[0].nom + "\n" + "\n PP : " + str(pokemonJoueur.listeAttaque[0].PP) + "/" + str(pokemonJoueur.listeAttaque[0].PP_max)
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque2".text = pokemonJoueur.listeAttaque[1].nom + "\n" + "\n PP : " + str(pokemonJoueur.listeAttaque[1].PP) + "/" + str(pokemonJoueur.listeAttaque[1].PP_max)
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque3".text = pokemonJoueur.listeAttaque[2].nom + "\n" + "\n PP : " + str(pokemonJoueur.listeAttaque[2].PP) + "/" + str(pokemonJoueur.listeAttaque[2].PP_max)
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque4".text = pokemonJoueur.listeAttaque[3].nom + "\n" + "\n PP : " + str(pokemonJoueur.listeAttaque[3].PP) + "/" + str(pokemonJoueur.listeAttaque[3].PP_max)
	
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque1/TextureRect".texture = load("res://Assets/Interface/Type/" + pokemonJoueur.listeAttaque[0].type + ".png")
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque2/TextureRect".texture = load("res://Assets/Interface/Type/" + pokemonJoueur.listeAttaque[1].type + ".png")
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque3/TextureRect".texture = load("res://Assets/Interface/Type/" + pokemonJoueur.listeAttaque[2].type + ".png")
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque4/TextureRect".texture = load("res://Assets/Interface/Type/" + pokemonJoueur.listeAttaque[3].type + ".png")

# Fonction qui un text petit à petit
func ecrire_texte(label: Label, texte: String, vitesse := 0.03):
	label.text = texte
	label.visible_characters = 0
	
	while label.visible_characters < texte.length():
		label.visible_characters += 1
		await get_tree().create_timer(vitesse).timeout
