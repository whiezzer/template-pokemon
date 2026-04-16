class_name PokemonData
extends Resource

@export var nom : String

# Référence locale à la liste des types (non exportée, injectée par le tool)
var _listeDesTypes : Array[Type] = []

var _type_index : int = 0

var type : Type:
	get:
		if _type_index < 0 or _type_index >= _listeDesTypes.size():
			return null
		return _listeDesTypes[_type_index]
	set(value):
		if value == null:
			_type_index = 0
			return
		_type_index = _listeDesTypes.find(value)
		if _type_index == -1:
			_type_index = 0

func _get_property_list():
	if _listeDesTypes.is_empty():
		return []
	var noms := _listeDesTypes.map(func(t): return t.nom)
	return [{
		"name": "_type_index",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(noms)
	}]

@export var pv : int:
	set(value):
		pv = max(value, 1)
var pv_Actuels : int 

@export var attaque : int:
	set(value):
		attaque = max(value, 1)

@export var defense : int:
	set(value):
		defense = max(value, 1)

@export var vitesse : int:
	set(value):
		vitesse = max(value, 1)

var listeAttaque : Array[Attaque]

var lvl : int = 1
var xp : int = 0
var xpObjectif : int = 1000
var nature : NatureStat

# Constructeur pour initialiser les valeurs directement
func _init(index = 0, _pv = 10, _attaque = 3, _def = 3, _vitesse = 3):
	_type_index = index
	_listeDesTypes = dataDuJeu.listeDesTypes
	pv = _pv
	pv_Actuels = _pv
	attaque = _attaque
	defense = _def
	vitesse = _vitesse
