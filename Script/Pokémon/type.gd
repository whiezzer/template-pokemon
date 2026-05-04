extends Resource
class_name Type

@export var nom : String:
	set(value):
		if value == "" or value == "Aucune":
			nom = "Pas de nom"
		elif value.length() > 10:
			nom = value.substr(0, 10)
		else:
			nom = value
		emit_changed()

@export var faiblesse : String:
	set(value):
		faiblesse = value if value != "" else "Aucune"
		faiblesse = value if value.length() < 10 else value.substr(0, 10)

@export var resistance : String:
	set(value):
		resistance = value if value != "" else "Aucune"
		resistance = value if value.length() < 10 else value.substr(0, 10)

# Constructeur pour initialiser les valeurs directement
func _init(_nom = "Pas de nom", _faiblesse = "Aucune", _resistance = "Aucune"):
	nom = _nom
	faiblesse = _faiblesse
	resistance = _resistance
