class_name PokemonData
extends Resource

var nom : String
var type : String
var pv : int
var pv_Actuels : int 
var attaque : int
var attaqueSpe : int
var defense : int
var defenseSpe : int
var vitesse : int

var listeAttaque : Array[String]

var lvl : int = 1
var xp : int = 0
var xpObjectif : int = 1000
var nature : NatureStat

# Fonction pour faire passer un pokémon au niveau suivant
func _niveauSuperieur() -> void:
	xp = xp - xpObjectif
	xpObjectif += 100
	lvl += 1
	pv += randi() % 10
	attaque += randi() % 5
	defense += randi() % 5
	attaqueSpe += randi() % 5
	defenseSpe += randi() % 5
	vitesse += randi() % 5

# Fonction qui attribue des attaques au pokémon selon son type
func _selectionAttaque() -> void:
	match type:
		"Feu":
			listeAttaque = ["Flamme", "Flamme", "Flamme", "Flamme"]
		"Plante":
			listeAttaque = ["Feuille Slash", "Feuille Slash", "Feuille Slash", "Feuille Slash"]
		"Eau":
			listeAttaque = ["Grosse Goutte", "Grosse Goutte", "Grosse Goutte", "Grosse Goutte"]

# Constructeur pour initialiser les valeurs directement
func _init(_nom = "PasDeNom", _type = "Feu", _pv = 10, _attaque = 10, _attaqueSpe = 10, _def = 10, _defSpe = 10, _vitesse = 10):
	nom = _nom
	type = _type
	pv = _pv
	pv_Actuels = _pv
	attaque = _attaque
	attaqueSpe = _attaqueSpe
	defense = _def
	defenseSpe = _defSpe
	vitesse = _vitesse
