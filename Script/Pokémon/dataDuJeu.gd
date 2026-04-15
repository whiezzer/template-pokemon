@tool
extends Node3D

# Liste de base de 6 natures avec leurs valeurs par défaut
var listeNatureDeBase : Array[NatureStat] = [
	NatureStat.new("attaque", "+10%", "defense", "-10%"),
	NatureStat.new("defense", "+10%", "attaque", "-10%"),
	NatureStat.new("pv", "+10%", "attaque", "-10%"),
	NatureStat.new("attaque", "+10%", "pv", "-10%"),
	NatureStat.new("vitesse", "+10%", "pv", "-10%"),
	NatureStat.new("pv", "+10%", "vitesse", "-10%")
]

# Liste de base de 3 objets avec leurs valeurs par défaut
var listeObjetsDeBase : Array[ObjetInventaire] = [
	ObjetInventaire.new(Objet.new("Pokéball", "Cette Objet sert à capturer des Pokémons", true), 10),
	ObjetInventaire.new(Objet.new("Potion de soin", "Cette Objet sert à soigner des pokémons", false, false, true, "75%"), 5),
	ObjetInventaire.new(Objet.new("Rappel", "Cette Objet sert à capturer des Pokemons", false, true, true, "25%"), 1)
]

@export_category("Paramètres des natures des pokémons")
# Liste de toutes les natures possibles visibles et modifiables dans l’inspecteur
@export var listeDesNatures : Array[NatureStat] = []:
	set(value):
		listeDesNatures = value
		_verifierNatures()

# Vérifie la liste et s'assure qu'elle contient toujours 6 natures
func _verifierNatures() -> void:
	if 5 == listeDesNatures.size():
		listeDesNatures.append(NatureStat.new())
	elif  5 > listeDesNatures.size():
		listeDesNatures = listeNatureDeBase
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

# Vérifie la liste et s'assure qu'elle contient toujours 3 objets
func _verifierObjets() -> void:
	if 2 == listeDesObjets.size():
		listeDesObjets.append(ObjetInventaire.new())
	elif  2 > listeDesObjets.size():
		listeDesObjets = listeObjetsDeBase
	else:
		for i in range(listeDesObjets.size()):
			if listeDesObjets[i] == null:
				listeDesObjets[i] = ObjetInventaire.new()

@export_category("Paramètres du Pokémon du joueur")
# Pokémon du joueur visible et modifiable dans l’inspecteur
@export var pokemonJoueurStats: PokemonData = PokemonData.new():
	set(value):
			pokemonJoueurStats = value
			_verifierPokemonJoueur()

# Vérifie le pokémon du joueur et s'assure qu'il existe
func _verifierPokemonJoueur() -> void:
	if pokemonJoueurStats == null:
		pokemonJoueurStats = PokemonData.new()

var pokemonEnnemiStats: PokemonData

# Appel automatique au démarrage pour s'assurer de la taille correcte
func _enter_tree() -> void:
	_verifierNatures()
	_verifierObjets()
	_verifierPokemonJoueur()
