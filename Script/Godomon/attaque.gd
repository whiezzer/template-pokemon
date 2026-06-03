@tool
extends Resource
class_name Attaque

@export var nom : String = "Pas de nom":
	set(value):
		nom = value if value != "" else "Pas de nom"
		if nom.length() > 20:
			nom = nom.substr(0, 20)
		emit_changed()

var _listeDesTypes : Array[Type] = []

var _type_index : int = 0

var type : String:
	get:
		if _listeDesTypes.is_empty() or _type_index < 0 or _type_index >= _listeDesTypes.size():
			return ""
		return _listeDesTypes[_type_index].nom
	set(value):
		if value == "" or _listeDesTypes.is_empty():
			_type_index = 0
			return
		for i in range(_listeDesTypes.size()):
			if _listeDesTypes[i].nom == value:
				_type_index = i
				return
		_type_index = 0

func _get_property_list():
	var scene_root = Engine.get_main_loop().edited_scene_root
	if scene_root:
		var param = scene_root.find_child("Paramètre", true, false)
		if param and param.get("listeDesTypes") != null:
			_listeDesTypes = param.get("listeDesTypes")
	
	var noms := _listeDesTypes.map(func(t): return t.nom)
	
	return [{
		"name": "_type_index",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(noms),
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_STORAGE
	}]

@export var puissance : int = 1:
	set(value):
		puissance = max(value, 1)

var PP : int

@export var PP_max : int = 1:
	set(value):
		PP_max = max(value, 1)

@export var precision : float = 1.0:
	set(value):
		precision = clamp(value, 0.0, 1.0)

@export var bruit : AudioStream = load("res://Assets/Son/Combat/son_Attaque1.wav"):
	set(value):
		if value == null:
			bruit = preload("res://Assets/Son/Combat/son_Attaque1.wav")
		else:
			bruit = value

# Constructeur pour initialiser les valeurs directement
func _init(_nom = "Pas de nom", _type = "Normal", _puissance = 3, _PP_max = 20, _precision = 1.0):
	nom = _nom
	type = _type
	puissance = _puissance
	PP_max = _PP_max
	precision = _precision
