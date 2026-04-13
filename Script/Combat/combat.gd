extends Node

var pokemonJoueur : PokemonData
var pokemonEnnemi : PokemonData
var tourDuJoueur : bool
var message : Label

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
	
	$InterfaceCombat/InterfaceInfoPokemon2/Texte_Nom.text = pokemonEnnemi.nom
	$InterfaceCombat/InterfaceInfoPokemon1/Texte_Nom.text = pokemonJoueur.nom
	
	$InterfaceCombat/InterfaceInfoPokemon2/Texte_Level.text += str(pokemonEnnemi.lvl)
	$InterfaceCombat/InterfaceInfoPokemon1/Texte_Level.text += str(pokemonJoueur.lvl)
	
	_misAJour_PV()

# Fonction appellé à chaque frame
func _physics_process(delta: float) -> void:
	if tourDuJoueur == false :
		_tour(pokemonEnnemi, pokemonJoueur)

# Fonction qui gère le tour de chaques pokémon lors d'un combat
func _tour(pokemon : PokemonData, cible : PokemonData) -> void:
	
	var attaqueUtilsé = pokemon.listeAttaque[randi() % 4]
	cible.pv_Actuels -= pokemon.attaque
	message.text = "  " + pokemon.nom + " utilise : " + attaqueUtilsé
	await get_tree().create_timer(1.0).timeout
	message.text = "  il inflige " + str(pokemon.attaque) + " dégats à " + cible.nom
	_misAJour_PV()
	await get_tree().create_timer(1.0).timeout
	_finDeTour()

# Fonction qui vérifie si le combat est terminé ou pas après le tour d'un combattant
func _finDeTour() -> void :
	
	if pokemonEnnemi.pv_Actuels <= 0:
		message.text = "  Victoire"
		pokemonJoueur.xp += 250
		pokemonEnnemi.pv_Actuels = pokemonEnnemi.pv
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Scene/ScenePrincipale.tscn")
	elif pokemonJoueur.pv_Actuels <= 0:
		message.text = "  Défaite"
		pokemonJoueur.pv_Actuels = pokemonJoueur.pv
		pokemonEnnemi.pv_Actuels = pokemonEnnemi.pv
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Scene/ScenePrincipale.tscn")
	else:
		if tourDuJoueur == true:
			tourDuJoueur = false
		else:
			tourDuJoueur = true

# Fonction qui met à jour les PV des pokemon dans l'interface
func _misAJour_PV():
	$InterfaceCombat/InterfaceInfoPokemon2/PV.value = pokemonEnnemi.pv_Actuels
	$InterfaceCombat/InterfaceInfoPokemon2/PV.max_value = pokemonEnnemi.pv
	
	$InterfaceCombat/InterfaceInfoPokemon1/PV.value = pokemonJoueur.pv_Actuels
	$InterfaceCombat/InterfaceInfoPokemon1/PV.max_value = pokemonJoueur.pv
