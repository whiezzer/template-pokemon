extends Resource
class_name Attaque

@export var nom : String:
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
	if _listeDesTypes.is_empty() and Engine.is_editor_hint():
		var scene_root = Engine.get_main_loop().edited_scene_root
		if scene_root:
			for child in scene_root.get_children():
				if child.get("listeDesTypes") != null:
					_listeDesTypes = child.get("listeDesTypes")
					break
	
	var noms := _listeDesTypes.map(func(t): return t.nom)
	
	return [{
		"name": "_type_index",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM if not _listeDesTypes.is_empty() else PROPERTY_HINT_NONE,
		"hint_string": ",".join(noms),
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_STORAGE
	}]

@export var puissance : int:
	set(value):
		puissance = max(value, 1)

var PP : int

@export var PP_max : int:
	set(value):
		PP_max = max(value, 1)

@export var precision : float:
	set(value):
		precision = clamp(value, 0.0, 1.0)

# Constructeur pour initialiser les valeurs directement
func _init(_nom = "Pas de nom", _type = "Normal", _puissance = 3, _PP_max = 20, _precision = 1.0):
	nom = _nom
	type = _type
	puissance = _puissance
	PP = _PP_max
	PP_max = _PP_max
	precision = _precision
