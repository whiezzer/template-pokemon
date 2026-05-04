@tool
extends Node3D

var _timerAttente : SceneTreeTimer = null

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
		Type.new("Normal", "Aucune", "Aucune"),
		Type.new("Feu", "Eau", "Plante"),
		Type.new("Eau", "Plante", "Feu"),
		Type.new("Plante", "Feu", "Eau")
	]

func _creer_liste_attaques_base() -> Array[Attaque]:
	var listeDeBase = []
	for type in listeDesTypes:
		listeDeBase.append(Attaque.new("Pas de nom", type.nom))
	return listeDeBase

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
	for i in range(listePokemonsJoueur.size()):
		if not listePokemonsJoueur[i]._listeDesTypes.is_empty():
			if listePokemonsJoueur[i]._type_index >= listePokemonsJoueur[i]._listeDesTypes.size():
				listePokemonsJoueur[i]._type_index = 0

@export_category("Paramètres des types")
# Liste des différents types visibles et modifiables dans l’inspecteur
@export var listeDesTypes: Array[Type] = []:
	set(value):
			
			for type in listeDesTypes:
				if type != null and type.changed.is_connected(_verifierTypeChange):
					type.changed.disconnect(_verifierTypeChange)
			
			listeDesTypes = value
			_verifierTypes()
			
			for type in listeDesTypes:
				if type != null and not type.changed.is_connected(_verifierTypeChange):
					type.changed.connect(_verifierTypeChange)
			
			_injecterTypesDansPokemonsDuJoueur()
			_injecterTypesDansAttaques()
			_verifierAttaques()
			_verifierPokemonsJoueur()
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

@export_category("Paramètres des attaques")
# Liste des différents attaques visibles et modifiables dans l’inspecteur
@export var listeDesAttaques: Array[Attaque] = []:
	set(value):
			listeDesAttaques = value
			_injecterTypesDansAttaques()
			_verifierAttaques()
			notify_property_list_changed()

# Vérifie la liste et s'assure qu'elle contient toujours au moins 1 attaque pour chaques types
func _verifierAttaques() -> void:
	for attaque in listeDesAttaques:
		if attaque._listeDesTypes.is_empty():
			return
	for i in range(listeDesAttaques.size()):
		if listeDesAttaques[i] == null:
			listeDesAttaques[i] = Attaque.new()
	var typesDejaCouvert : Array[String] = []
	for attaque in listeDesAttaques:
		if attaque.type != "" and attaque.type not in typesDejaCouvert:
			typesDejaCouvert.append(attaque.type)
	for type in listeDesTypes:
		if type.nom not in typesDejaCouvert:
			var nouvelleAttaque = Attaque.new("Pas de nom")
			nouvelleAttaque._listeDesTypes = listeDesTypes
			nouvelleAttaque.type = type.nom  
			listeDesAttaques.append(nouvelleAttaque)
	if listeDesAttaques == []:
		listeDesAttaques = _creer_liste_attaques_base()
	for i in range(listeDesAttaques.size()):
		if listeDesAttaques[i]._type_index >= listeDesTypes.size():
			listeDesAttaques[i]._type_index = 0

var pokemonJoueurStats: PokemonData
var pokemonEnnemiStats: PokemonData

# Injecte listeDesTypes dans chaque Pokémon pour que l'enum soit visible
func _injecterTypesDansPokemonsDuJoueur() -> void:
	for pokemon in listePokemonsJoueur:
		if pokemon != null:
			pokemon._listeDesTypes = listeDesTypes
			pokemon.notify_property_list_changed()

# Injecte listeDesTypes dans chaque Attaque
func _injecterTypesDansAttaques() -> void:
	for attaque in listeDesAttaques:
		if attaque != null:
			attaque._listeDesTypes = listeDesTypes
			attaque.notify_property_list_changed()

# Fonction qui vérifie si le nom d'un type n'a pas changer
func _verifierTypeChange() -> void:
	if _timerAttente != null and _timerAttente.time_left > 0:
		_timerAttente.stop()
	
	_timerAttente = get_tree().create_timer(5.0) 
	await _timerAttente.timeout
	
	_injecterTypesDansPokemonsDuJoueur()
	_injecterTypesDansAttaques()
	_verifierAttaques()
	_verifierPokemonsJoueur()
	notify_property_list_changed()

# Appel automatique au démarrage pour s'assurer de la taille correcte
func _enter_tree() -> void:
	_injecterTypesDansAttaques()
	_injecterTypesDansPokemonsDuJoueur()
	dataDuJeu.listeDesNatures = listeDesNatures
	dataDuJeu.listeDesObjets = listeDesObjets
	dataDuJeu.listePokemonsJoueur = listePokemonsJoueur
	dataDuJeu.listeDesTypes = listeDesTypes
	dataDuJeu.listeDesAttaques = listeDesAttaques
	dataDuJeu.pokemonJoueurStats = listePokemonsJoueur[0]
