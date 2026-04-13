extends Node
class_name Combat

# # Fonction appellé au lancement du combat
func _ready() -> void:
	get_parent().get_node("InterfaceCombat/InterfaceInfoPokemon2/Texte_Nom").text = dataDuJeu.pokemonEnnemiStats.nom
	get_parent().get_node("InterfaceCombat/InterfaceInfoPokemon1/Texte_Nom").text = dataDuJeu.pokemonJoueurStats.nom
	
	get_parent().get_node("InterfaceCombat/InterfaceInfoPokemon2/Texte_Level").text += str(dataDuJeu.pokemonEnnemiStats.lvl)
	get_parent().get_node("InterfaceCombat/InterfaceInfoPokemon1/Texte_Level").text += str(dataDuJeu.pokemonJoueurStats.lvl)

# Fonction qui met à jour les PV des pokemon dans l'interface
func _MisAJour_PV():
	get_parent().get_node("InterfaceCombat/InterfaceInfoPokemon2/PV").value = dataDuJeu.pokemonEnnemiStats.pv_Actuels
	get_parent().get_node("InterfaceCombat/InterfaceInfoPokemon2/PV").max_value = dataDuJeu.pokemonEnnemiStats.pv
	
	get_parent().get_node("InterfaceCombat/InterfaceInfoPokemon1/PV").value = dataDuJeu.pokemonJoueurStats.pv_Actuels
	get_parent().get_node("InterfaceCombat/InterfaceInfoPokemon1/PV").max_value = dataDuJeu.pokemonJoueurStats.pv

# Fonction qui gère les combats
func _combat() -> void:
	
	_MisAJour_PV()
	
	print("début du combat")
	
	await get_tree().create_timer(1.0).timeout
	
	var pokemonJoueur = dataDuJeu.pokemonJoueurStats
	var pokemonEnnemi = dataDuJeu.pokemonEnnemiStats
	
	while pokemonJoueur.pv_Actuels > 0 || pokemonEnnemi.pv_Actuels > 0: 
			if pokemonJoueur.vitesse >= pokemonEnnemi.vitesse:
				_tour(pokemonJoueur)
				if pokemonEnnemi.pv_Actuels > 0:
					_tour(pokemonEnnemi)
			else:
				_tour(pokemonEnnemi)
				if pokemonJoueur.pv_Actuels > 0:
					_tour(pokemonJoueur)
	
	await get_tree().create_timer(2.0).timeout
	
	if pokemonEnnemi.pv_Actuels <= 0:
		print("Victoire")
		pokemonJoueur.xp += 250
		pokemonEnnemi.pv_Actuels = pokemonEnnemi.pv
	else :
		print("Défaite")
		pokemonJoueur.pv_Actuels = pokemonJoueur.pv
		pokemonEnnemi.pv_Actuels = pokemonEnnemi.pv
	
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scene/ScenePrincipale.tscn")

# Fonction qui gère le tour de chaques pokémon lors d'un combat
func _tour(pokemon : PokemonData) -> void:
	
	var attaqueUtilsé = pokemon.listeAttaque[randi() % 4]
	pokemon.pv_Actuels -= pokemon.attaque
	print(pokemon.nom + " utilise : " + attaqueUtilsé)
	await get_tree().create_timer(1.0).timeout
	print("il inflige " + str(pokemon.attaque) + " dégats à " + pokemon.nom)
	_MisAJour_PV()
	await get_tree().create_timer(1.0).timeout
