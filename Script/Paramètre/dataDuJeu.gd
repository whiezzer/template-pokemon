@tool
extends Node3D

# Fonction qui crée des boutons d'objets dans le menu objets par rapport au nombre d'objets dans la ListeDesObjets
func _créerBoutonsMenuObjet() -> void:
	var positionBoutonObjets = Vector2(150.0, 142.0)
	
	for objet in listeDesObjets:
		
		var label = Label.new()
		var bouton = TextureButton.new()
		bouton.set_script(preload("res://Script/Interface/boutonObjet.gd"))
		bouton.objetNom = label
		
		get_tree().current_scene.get_node("InterfaceMenu/MenuObjet").add_child(bouton)
		get_tree().current_scene.get_node("InterfaceMenu/MenuObjet").add_child(label)
		
		bouton.objet = objet
		bouton.position = positionBoutonObjets
		bouton.set_anchors_preset(Control.PRESET_TOP_LEFT)
		bouton.size = Vector2(400.0, 50.0)
		bouton.texture_normal = preload("res://Assets/Interface/Sac/SelectionSac.png")
		bouton.texture_pressed = preload("res://Assets/Interface/Sac/SelectionSacAppuyer.png")
		bouton.stretch_mode = TextureButton.STRETCH_SCALE
		bouton.mouse_entered.connect(bouton._on_mouse_entered)
		
		label.text = objet.objet.nom
		label.add_theme_font_override("font", preload("res://Assets/Text/pixel_operator/PixelOperator.ttf"))
		label.add_theme_font_size_override("font_size", 45)
		label.position = positionBoutonObjets
		label.position.x += -200.0
		label.size = Vector2(800.0, 35.0)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		positionBoutonObjets.y += 85.0

var _timerAttente : SceneTreeTimer = null
var coordonésJoueurs : Vector3 = Vector3(99.0, 99.0, 99.0)

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
		ObjetInventaire.new(Objet.new("Pokéball", load("res://Assets/Objets/Pokeballs/Pokeball attraper57.png") , "Cette Objet sert à capturer des Pokémons", true, false, false, "0%"), 10),
		ObjetInventaire.new(Objet.new("Potion de soin", null ,"Cette Objet sert à soigner des pokémons", false, false, true, "75%"), 5),
		ObjetInventaire.new(Objet.new("Rappel", null, "Cette Objet sert à réanimer des Pokemons", false, true, true, "25%"), 1)
	]

# Liste de base de 3 types avec leurs valeurs par défaut
func _creer_liste_types_base() -> Array[Type]:
	return [
		Type.new("Normal", "Aucune", "Aucune"),
		Type.new("Feu", "Eau", "Plante", Color(0.947, 0.264, 0.236, 1.0)),
		Type.new("Eau", "Plante", "Feu", Color(0.0, 0.636, 0.952, 1.0)),
		Type.new("Plante", "Feu", "Eau", Color(0.247, 0.516, 0.162, 1.0))
	]

func _creer_liste_attaques_base() -> Array[Attaque]:
	var listeDeBase = []
	for type in listeDesTypes:
		listeDeBase.append(Attaque.new("Attaque" + type.nom, type.nom))
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
		if 6 < listeDesObjets.size():
			listeDesObjets.pop_at(5)
		for i in range(listeDesObjets.size()):
			if listeDesObjets[i] == null:
				listeDesObjets[i] = ObjetInventaire.new()

@export_category("Paramètres des Pokémons")
# Liste des Pokémons visibles et modifiables dans l’inspecteur
@export var listePokemons: Array[PokemonData] = []:
	set(value):
			listePokemons = value
			
			_verifierPokemons()
			_injecterTypesDansPokemons()
			_verifierPokemonJoueur()
			notify_property_list_changed()

# Vérifie les pokémons et s'assure qu'il existe au moins 1 pokémon
func _verifierPokemons() -> void:
	if 1 > listePokemons.size():
		listePokemons = [PokemonData.new()]
		listePokemons[0].nom = "Bomjeton"
	else:
		for i in range(listePokemons.size()):
			if listePokemons[i] == null:
				listePokemons[i] = PokemonData.new()
	for i in range(listePokemons.size()):
		if not listePokemons[i]._listeDesTypes.is_empty():
			if listePokemons[i]._type_index >= listePokemons[i]._listeDesTypes.size():
				listePokemons[i]._type_index = 0

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
			
			_injecterTypesDansPokemons()
			_injecterTypesDansAttaques()
			_verifierAttaques()
			_verifierPokemons()
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
	for i in range(listeDesAttaques.size()):
		if listeDesAttaques[i] == null:
			listeDesAttaques[i] = Attaque.new()
	var typesDejaCouvert : Array[String] = []
	for attaque in listeDesAttaques:
		if attaque.type != "" and attaque.type not in typesDejaCouvert:
			typesDejaCouvert.append(attaque.type)
	for type in listeDesTypes:
		if type.nom not in typesDejaCouvert:
			var nouvelleAttaque = Attaque.new("Attaque")
			nouvelleAttaque._listeDesTypes = listeDesTypes
			nouvelleAttaque.type = type.nom  
			listeDesAttaques.append(nouvelleAttaque)
	if listeDesAttaques == []:
		listeDesAttaques = _creer_liste_attaques_base()
	for i in range(listeDesAttaques.size()):
		if listeDesAttaques[i]._type_index >= listeDesTypes.size():
			listeDesAttaques[i]._type_index = 0

var _type_index_pokemons_joueurs : int = 0

@export_category("Pokémon de départ du joueur")
# Pokémon de départ du joueur visible et modifiable dans l’inspecteur
var pokemonJoueurStats: PokemonData:
	get:
		if listePokemons.is_empty() or _type_index_pokemons_joueurs < 0 or _type_index_pokemons_joueurs >= listePokemons.size():
			return 
		return listePokemons[_type_index_pokemons_joueurs]
	set(value):
		pokemonJoueurStats = value
		_verifierPokemonJoueur()

func _verifierPokemonJoueur() -> void:
	if pokemonJoueurStats == null or listePokemons.is_empty():
		_type_index_pokemons_joueurs = 0
		return
	for i in range(listePokemons.size()):
		if listePokemons[i] == pokemonJoueurStats:
			_type_index_pokemons_joueurs = i
			return
	_type_index_pokemons_joueurs = 0

func _get_property_list():
	var noms := listePokemons.map(func(t): return t.nom)
	
	return [{
		"name": "_type_index_pokemons_joueurs",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM if not listePokemons.is_empty() else PROPERTY_HINT_NONE,
		"hint_string": ",".join(noms),
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_STORAGE 
	}]

var indexPokemonJoueurActif: int = 0

var listePokemonsJoueur: Array[PokemonData] = []

var pokemonEnnemiStats: PokemonData

var listePokemonsEnnemie: Array[PokemonData] = []

# Injecte listeDesTypes dans chaque Pokémon pour que l'enum soit visible
func _injecterTypesDansPokemons() -> void:
	for pokemon in listePokemons:
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
	
	_injecterTypesDansPokemons()
	_injecterTypesDansAttaques()
	_verifierAttaques()
	_verifierPokemons()
	_verifierPokemonJoueur()
	notify_property_list_changed()   

# Appel automatique au démarrage pour s'assurer que tout est correct
func _enter_tree() -> void:
	var ref = get_tree().current_scene.find_child("Paramètre", true, false)
	dataDuJeu.listeDesNatures = ref.listeDesNatures
	dataDuJeu.listeDesObjets = ref.listeDesObjets
	dataDuJeu.listeDesTypes = ref.listeDesTypes
	_injecterTypesDansAttaques()
	_injecterTypesDansPokemons()
	for i in range(ref.listeDesAttaques.size()):
		ref.listeDesAttaques[i].PP =ref.listeDesAttaques[i].PP_max
	dataDuJeu.listePokemons = ref.listePokemons
	dataDuJeu.listeDesAttaques = ref.listeDesAttaques
	if dataDuJeu.listePokemonsJoueur == []:
		dataDuJeu._type_index_pokemons_joueurs = ref._type_index_pokemons_joueurs
		listePokemonsJoueur.append(pokemonJoueurStats)
	_créerBoutonsMenuObjet()
