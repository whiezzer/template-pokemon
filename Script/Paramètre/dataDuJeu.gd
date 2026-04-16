@tool
extends Node3D

# Liste de base de 6 natures avec leurs valeurs par défaut
func _creer_liste_nature_base() -> Array[NatureStat]:
	return [
		NatureStat.new("attaque", "+10%", "defense", "-10%"),
		NatureStat.new("defense", "+10%", "attaque", "-10%"),
		NatureStat.new("pv", "+10%", "attaque", "-10%"),
		NatureStat.new("attaque", "+10%", "pv", "-10%"),
		NatureStat.new("vitesse", "+10%", "pv", "-10%"),
		NatureStat.new("pv", "+10%", "vitesse", "-10%")
	]

# Liste de base de 3 objets avec leurs valeurs par défaut
func _creer_liste_objets_base() -> Array[ObjetInventaire]:
	return [
		ObjetInventaire.new(Objet.new("Pokéball", "Cette Objet sert à capturer des Pokémons", true, false, false, "0%"), 10),
		ObjetInventaire.new(Objet.new("Potion de soin", "Cette Objet sert à soigner des pokémons", false, false, true, "75%"), 5),
		ObjetInventaire.new(Objet.new("Rappel", "Cette Objet sert à réanimer des Pokemons", false, true, true, "25%"), 1)
	]

# Liste de base de 3 types avec leurs valeurs par défaut
func _creer_liste_types_base() -> Array[Type]:
	return [
		Type.new("Feu", "Eau", "Plante"),
		Type.new("Eau", "Plante", "Feu"),
		Type.new("Plante", "Feu", "Eau")
	]

@export_category("Paramètres des natures des pokémons")
# Liste de toutes les natures possibles visibles et modifiables dans l’inspecteur
@export var listeDesNatures : Array[NatureStat] = []:
	set(value):
		listeDesNatures = value
		_verifierNatures()
		notify_property_list_changed()

# Vérifie la liste et s'assure qu'elle contient toujours 6 natures
func _verifierNatures() -> void:
	if 5 == listeDesNatures.size():
		listeDesNatures.append(NatureStat.new())
	elif  5 > listeDesNatures.size():
		listeDesNatures = _creer_liste_nature_base()
	else:
		for i in range(listeDesNatures.size()):
			if listeDesNatures[i] == null:
				listeDesNatures[i] = NatureStat.new()

@export_category("Paramètres des objets")
# Liste de tous les objets possibles visibles et modifiables dans l’inspecteur
@export var listeDesObjets : Array[ObjetInventaire] = []:
	set(value):
		listeDesObjets = value
		_verifierObjets()
		notify_property_list_changed()

# Vérifie la liste et s'assure qu'elle contient toujours 3 objets
func _verifierObjets() -> void:
	if 2 == listeDesObjets.size():
		listeDesObjets.append(ObjetInventaire.new())
	elif 2 > listeDesObjets.size():
		listeDesObjets = _creer_liste_objets_base()
	else:
		for i in range(listeDesObjets.size()):
			if listeDesObjets[i] == null:
				listeDesObjets[i] = ObjetInventaire.new()

@export_category("Paramètres des Pokémons du joueur")
# Liste des Pokémons du joueur visibles et modifiables dans l’inspecteur
@export var listePokemonsJoueur: Array[PokemonData] = []:
	set(value):
			listePokemonsJoueur = value
			_verifierPokemonsJoueur()
			_injecterTypesDansPokemonsDuJoueur()
			notify_property_list_changed()

# Vérifie le pokémon du joueur et s'assure qu'il existe
func _verifierPokemonsJoueur() -> void:
	if 1 > listePokemonsJoueur.size():
		listePokemonsJoueur = [PokemonData.new()]
	else:
		for i in range(listePokemonsJoueur.size()):
			if listePokemonsJoueur[i] == null:
				listePokemonsJoueur[i] = PokemonData.new()

@export_category("Paramètres des types")
# Liste des différents types visibles et modifiables dans l’inspecteur
@export var listeDesTypes: Array[Type] = []:
	set(value):
			listeDesTypes = value
			_verifierTypes()
			_injecterTypesDansPokemonsDuJoueur()
			notify_property_list_changed()

# Vérifie la liste et s'assure qu'elle contient toujours 6 natures
func _verifierTypes() -> void:
	if 2 == listeDesTypes.size():
		listeDesTypes.append(Type.new())
	elif  2 > listeDesTypes.size():
		listeDesTypes = _creer_liste_types_base()
	else:
		for i in range(listeDesTypes.size()):
			if listeDesTypes[i] == null:
				listeDesTypes[i] = Type.new()

var pokemonJoueurStats: PokemonData
var pokemonEnnemiStats: PokemonData

# Injecte listeDesTypes dans chaque PokemonData pour que l'enum soit visible
func _injecterTypesDansPokemonsDuJoueur() -> void:
	for pokemon in listePokemonsJoueur:
		if pokemon != null:
			pokemon._listeDesTypes = listeDesTypes
			pokemon.notify_property_list_changed()

# Appel automatique au démarrage pour s'assurer de la taille correcte
func _enter_tree() -> void:
	_injecterTypesDansPokemonsDuJoueur()
	dataDuJeu.listeDesNatures = listeDesNatures
	dataDuJeu.listeDesObjets = listeDesObjets
	dataDuJeu.listePokemonsJoueur = listePokemonsJoueur
	dataDuJeu.pokemonJoueurStats = listePokemonsJoueur[0]
	dataDuJeu.listeDesTypes = listeDesTypes
