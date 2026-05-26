@tool
extends Node3D

var menuPrincipalActif : bool = true

var objetUtilisé : ObjetInventaire

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
		bouton.mouse_exited.connect(bouton._on_mouse_exited)
		bouton.pressed.connect(bouton._on_pressed)
		
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

var listeDesDresseurs : Dictionary[String, bool] = {}
var adversaire : String = ""

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
		ObjetInventaire.new(Objet.new("Godoball", load("res://Assets/Objets/Pokeballs/Pokeball attraper57.png") , "Cette Objet sert à capturer des Godomons", true, false, false, "0%"), 10),
		ObjetInventaire.new(Objet.new("Potion de soin", null ,"Cette Objet sert à soigner des Godomons", false, false, true, "75%"), 5),
		ObjetInventaire.new(Objet.new("Rappel", null, "Cette Objet sert à réanimer des Godomons", false, true, false, "25%"), 1)
	]

# Liste de base de 3 types avec leurs valeurs par défaut
func _creer_liste_types_base() -> Array[Type]:
	return [
		Type.new("Normal", "Aucune", "Aucune"),
		Type.new("Feu", "Eau", "Plante", Color(0.947, 0.264, 0.236, 1.0)),
		Type.new("Eau", "Plante", "Feu", Color(0.0, 0.636, 0.952, 1.0)),
		Type.new("Plante", "Feu", "Eau", Color(0.247, 0.516, 0.162, 1.0))
	]

# Liste de base de 3 Godomons avec leurs valeurs par défaut
func _creer_liste_pokemon_base() -> Array[GodomonData]:
	return [
		GodomonData.new(0, 10, 5, 5, 3, "Tic"),
		GodomonData.new(1, 10, 5, 5, 3, "Bonjeton", load("res://Assets/Son/Crie de pokemon/Bomjeton_CRIE.wav"), load("res://Assets/Godomon/Bomjeton/BomjetonFace.png"), load("res://Assets/Godomon/Bomjeton/BomjetonDos.png")),
		GodomonData.new(2, 10, 5, 5, 3, "Sinjypleur", load("res://Assets/Son/Crie de pokemon/Sinjypleur_CRIE.wav"), load("res://Assets/Godomon/Sinjypleur/SinjypleurFace.png"), load("res://Assets/Godomon/Sinjypleur/SinjypleurDos.png")),
		GodomonData.new(3, 10, 5, 5, 3, "Cabufo", load("res://Assets/Son/Crie de pokemon/Frog_CRIE.wav"), load("res://Assets/Godomon/Cabufo/CabufoFace.png"), load("res://Assets/Godomon/Cabufo/CabufoDos.png"))
	]

func _creer_liste_attaques_base() -> Array[Attaque]:
	var listeDeBase = []
	for type in listeDesTypes:
		listeDeBase.append(Attaque.new("Attaque" + type.nom, type.nom))
	return listeDeBase

@export_category("Paramètres des natures des Godomons")
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

@export_category("Paramètres des Godomons")
# Liste des Godomons visibles et modifiables dans l’inspecteur
@export var listeGodomons: Array[GodomonData] = []:
	set(value):
			listeGodomons = value
			
			_verifierGodomons()
			_injecterTypesDansGodomons()
			_verifierGodomonJoueur()
			notify_property_list_changed()

# Vérifie les Godomons et s'assure qu'il existe au moins 1 pokémon
func _verifierGodomons() -> void:
	if 1 > listeGodomons.size():
		listeGodomons = _creer_liste_pokemon_base()
	else:
		for i in range(listeGodomons.size()):
			if listeGodomons[i] == null:
				listeGodomons[i] = GodomonData.new()
	for i in range(listeGodomons.size()):
		if not listeGodomons[i]._listeDesTypes.is_empty():
			if listeGodomons[i]._type_index >= listeGodomons[i]._listeDesTypes.size():
				listeGodomons[i]._type_index = 0

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
			
			_injecterTypesDansGodomons()
			_injecterTypesDansAttaques()
			_verifierAttaques()
			_verifierGodomons()
			notify_property_list_changed()

# Vérifie la liste et s'assure qu'elle contient toujours 6 natures
func _verifierTypes() -> void:
	if  2 > listeDesTypes.size():
		listeDesTypes = _creer_liste_types_base()
	else:
		for i in range(listeDesTypes.size()):
			if listeDesTypes[i] == null:
				listeDesTypes[i] = Type.new()
	
	var typeDeBaseNom = ["Normal" ,"Feu", "Eau", "Plante"]
	
	for typeNomIndex in range(typeDeBaseNom.size()):
		for type in listeDesTypes:
			if typeDeBaseNom[typeNomIndex] == type.nom:
				typeDeBaseNom[typeNomIndex] = "OK"
	
	for i in range (typeDeBaseNom.size()):
		if typeDeBaseNom[i] != "OK":
			listeDesTypes.insert(i, _creer_liste_types_base()[i])

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
	for i in range(listeDesTypes.size()):
		if listeDesTypes[i].nom not in typesDejaCouvert:
			var nomAttaques = ["Flick", "Ignis", "Cirkeau", "Folium-Crucis"]
			var nouvelleAttaque = Attaque.new("Attaque")
			nouvelleAttaque._listeDesTypes = listeDesTypes
			nouvelleAttaque.type = listeDesTypes[i].nom
			if i < nomAttaques.size():
				nouvelleAttaque.nom = nomAttaques[i]
			else:
				nouvelleAttaque.nom = listeDesTypes[i].nom 
			listeDesAttaques.insert(i, nouvelleAttaque)
	if listeDesAttaques == []:
		listeDesAttaques = _creer_liste_attaques_base()
	for i in range(listeDesAttaques.size()):
		if listeDesAttaques[i]._type_index >= listeDesTypes.size():
			listeDesAttaques[i]._type_index = 0

var _type_index_Godomons_joueurs : int = 0

# Godomon de départ du joueur visible et modifiable dans l’inspecteur
var pokemonJoueurStats: GodomonData:
	get:
		if listeGodomonsJoueur.is_empty() or indexGodomonJoueurActif < 0 or indexGodomonJoueurActif >= listeGodomonsJoueur.size():
			return 
		return listeGodomonsJoueur[indexGodomonJoueurActif]
	set(value):
		pokemonJoueurStats = value
		_verifierGodomonJoueur()

func _verifierGodomonJoueur() -> void:
	if pokemonJoueurStats == null or listeGodomons.is_empty():
		_type_index_Godomons_joueurs = 0
		return
	for i in range(listeGodomons.size()):
		if listeGodomons[i] == pokemonJoueurStats:
			_type_index_Godomons_joueurs = i
			return
	_type_index_Godomons_joueurs = 0

func _get_property_list():
	var noms := listeGodomons.map(func(t): return t.nom)
	
	return [{
		"name": "_type_index_Godomons_joueurs",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM if not listeGodomons.is_empty() else PROPERTY_HINT_NONE,
		"hint_string": ",".join(noms),
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_STORAGE 
	}]

var indexGodomonJoueurActif: int = 0

var listeGodomonsJoueur: Array[GodomonData] = []

var pokemonEnnemiStats: GodomonData

var listeGodomonsEnnemie: Array[GodomonData] = []

@export_category("Paramétres Audios")
@export var musiqueMenu : AudioStream:
	set(value):
		if value == null:
			musiqueMenu = load("res://Assets/Son/menu/musiqueMenu.mp3")
		else:
			musiqueMenu = value
@export var musiquePrincipal : AudioStream:
	set(value):
		if value == null:
			musiquePrincipal = load("res://Assets/Son/environnement/musique_Environnement.mp3")
		else:
			musiquePrincipal = value
@export var musiqueCombat : AudioStream:
	set(value):
		if value == null:
			musiqueCombat = load("res://Assets/Son/Combat/musique_Fight.mp3")
		else:
			musiqueCombat = value
@export var musiqueTransitionCombat : AudioStream:
	set(value):
		if value == null:
			musiqueTransitionCombat = load("res://Assets/Son/Combat/son_TransitionCombat.wav")
		else:
			musiqueTransitionCombat = value
@export var musiqueVictoire : AudioStream:
	set(value):
		if value == null:
			musiqueVictoire = load("res://Assets/Son/Combat/Victoire.mp3")
		else:
			musiqueVictoire = value

@export_category("Godomon de départ")

# Injecte listeDesTypes dans chaque Godomon pour que l'enum soit visible
func _injecterTypesDansGodomons() -> void:
	for pokemon in listeGodomons:
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
	
	_injecterTypesDansGodomons()
	_injecterTypesDansAttaques()
	_verifierAttaques()
	_verifierGodomons()
	_verifierGodomonJoueur()
	notify_property_list_changed()   

# Appel automatique au démarrage pour s'assurer que tout est correct
func _enter_tree() -> void:
	var ref = get_tree().current_scene.find_child("Paramètre", true, false)
	dataDuJeu.listeDesNatures = ref.listeDesNatures
	dataDuJeu.listeDesObjets = ref.listeDesObjets
	dataDuJeu.listeDesTypes = ref.listeDesTypes
	_injecterTypesDansAttaques()
	_injecterTypesDansGodomons()
	for i in range(ref.listeDesAttaques.size()):
		ref.listeDesAttaques[i].PP =ref.listeDesAttaques[i].PP_max
	dataDuJeu.listeGodomons = ref.listeGodomons
	dataDuJeu.listeDesAttaques = ref.listeDesAttaques
	dataDuJeu._type_index_Godomons_joueurs = ref._type_index_Godomons_joueurs
	listeGodomonsJoueur.append(listeGodomons[_type_index_Godomons_joueurs])
	_créerBoutonsMenuObjet()
	
	if dataDuJeu.menuPrincipalActif:
		get_tree().current_scene.get_node("InterfaceMenuPrincipal").visible = true
	
	dataDuJeu.musiqueMenu = ref.musiqueMenu
	dataDuJeu.musiquePrincipal = ref.musiquePrincipal
	dataDuJeu.musiqueCombat = ref.musiqueCombat
	dataDuJeu.musiqueTransitionCombat = ref.musiqueTransitionCombat
	dataDuJeu.musiqueVictoire = ref.musiqueVictoire
