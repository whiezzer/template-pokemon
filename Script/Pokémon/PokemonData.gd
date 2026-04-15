class_name PokemonData
extends Resource

@export var nom : String

@export_enum("Feu", "Plante", "Eau")
var type : String
var faiblesse : String
var resistance : String

@export var pv : int
var pv_Actuels : int 

@export var attaque : int

@export var defense : int

@export var vitesse : int

var listeAttaque : Array[Attaque]

var lvl : int = 1
var xp : int = 0
var xpObjectif : int = 1000
var nature : NatureStat

# Constructeur pour initialiser les valeurs directement
func _init(_type = "Feu", _pv = 10, _attaque = 3, _def = 3, _vitesse = 3):
	type = _type
	pv = _pv
	pv_Actuels = _pv
	attaque = _attaque
	defense = _def
	vitesse = _vitesse
