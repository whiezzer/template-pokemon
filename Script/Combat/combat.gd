extends Node

var pokemonJoueur : PokemonData

var pokemonEnnemi : PokemonData

var tourDuJoueur : bool

var message : Label

var enCoursDeTour : bool = false

var finCombat : bool = false

# Fonction appellé au lancement du combat
func  _ready() -> void:
	
	pokemonJoueur = dataDuJeu.pokemonJoueurStats
	pokemonEnnemi = dataDuJeu.pokemonEnnemiStats
	message = $InterfaceCombat/ZoneDeTexte2
	
	message.text = "  Début du combat"
	
	if pokemonJoueur.vitesse >= pokemonEnnemi.vitesse:
		tourDuJoueur = true
	else :
		tourDuJoueur = false
	
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
	
	attaqueUtilse.PP -= 1
	
	_misAJourInterface()
	
	pokemonJoueur.pv_Actuels -= degatsInflige
	
	message.text = pokemonEnnemi.nom + " utilise : " + attaqueUtilse.nom
	
	await get_tree().create_timer(1.0).timeout
	
	message.text += "\nIl inflige " + str(degatsInflige) + " dégâts"
	
	_misAJourInterface()
	
	await get_tree().create_timer(1.0).timeout
	
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
	
	attaque.PP -= 1
	
	_misAJourInterface()
	
	pokemonEnnemi.pv_Actuels -= degatsInflige
	
	message.text = pokemonJoueur.nom + " utilise : " + attaque.nom
	
	await get_tree().create_timer(1.0).timeout
	
	message.text += "\nIl inflige " + str(degatsInflige) + " dégâts"
	
	_misAJourInterface()
	
	await get_tree().create_timer(1.0).timeout
	
	_finDeTour()
	
	if finCombat == false:
		
		enCoursDeTour = false
		tourDuJoueur = false
		
		await _tourAdverse()

# Fonction qui vérifie si le combat est terminé ou pas après le tour d'un combattant
func _finDeTour() -> void :
	
	if pokemonEnnemi.pv_Actuels <= 0:
		
		finCombat = true
		message.text = "  Victoire"
		await get_tree().create_timer(1.0).timeout
		pokemonJoueur.xp += 250
		pokemonEnnemi.pv_Actuels = pokemonEnnemi.pv
		get_tree().change_scene_to_file("res://Scene/ScenePrincipale.tscn")
		
	elif pokemonJoueur.pv_Actuels <= 0:
		
		finCombat = true
		message.text = "  Défaite"
		await get_tree().create_timer(1.0).timeout
		pokemonJoueur.pv_Actuels = pokemonJoueur.pv
		pokemonEnnemi.pv_Actuels = pokemonEnnemi.pv
		pokemonEnnemi.listeAttaque[0].PP = pokemonEnnemi.listeAttaque[0].PP_max
		pokemonEnnemi.listeAttaque[1].PP = pokemonEnnemi.listeAttaque[1].PP_max
		pokemonEnnemi.listeAttaque[2].PP = pokemonEnnemi.listeAttaque[2].PP_max
		pokemonEnnemi.listeAttaque[3].PP = pokemonEnnemi.listeAttaque[3].PP_max
		get_tree().change_scene_to_file("res://Scene/ScenePrincipale.tscn")

# Fonction qui met à jour l'interface
func _misAJourInterface():
	$InterfaceCombat/InterfaceInfoPokemon2/PV.value = pokemonEnnemi.pv_Actuels
	$InterfaceCombat/InterfaceInfoPokemon2/PV.max_value = pokemonEnnemi.pv
	
	$InterfaceCombat/InterfaceInfoPokemon1/PV.value = pokemonJoueur.pv_Actuels
	$InterfaceCombat/InterfaceInfoPokemon1/PV.max_value = pokemonJoueur.pv
	
	$InterfaceCombat/InterfaceInfoPokemon2/Texte_Nom.text = pokemonEnnemi.nom
	$InterfaceCombat/InterfaceInfoPokemon1/Texte_Nom.text = pokemonJoueur.nom
	
	$InterfaceCombat/InterfaceInfoPokemon2/Texte_Level.text = "nv : " + str(pokemonEnnemi.lvl)
	$InterfaceCombat/InterfaceInfoPokemon1/Texte_Level.text = "nv : " + str(pokemonJoueur.lvl)
	
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque1".text = pokemonJoueur.listeAttaque[0].nom + "\n" + "\n PP : " + str(pokemonJoueur.listeAttaque[0].PP) + "/" + str(pokemonJoueur.listeAttaque[0].PP_max)
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque2".text = pokemonJoueur.listeAttaque[1].nom + "\n" + "\n PP : " + str(pokemonJoueur.listeAttaque[1].PP) + "/" + str(pokemonJoueur.listeAttaque[1].PP_max)
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque3".text = pokemonJoueur.listeAttaque[2].nom + "\n" + "\n PP : " + str(pokemonJoueur.listeAttaque[2].PP) + "/" + str(pokemonJoueur.listeAttaque[2].PP_max)
	$"InterfaceCombat/MenuAttaque/Bouton-Attaque4".text = pokemonJoueur.listeAttaque[3].nom + "\n" + "\n PP : " + str(pokemonJoueur.listeAttaque[3].PP) + "/" + str(pokemonJoueur.listeAttaque[3].PP_max)
	
