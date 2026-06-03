extends Resource
class_name Type

@export var nom : String = "Pas de nom":
	set(value):
		if value == "" or value == "Aucune":
			nom = "Pas de nom"
		elif value.length() > 10:
			nom = value.substr(0, 10)
		else:
			nom = value
		emit_changed()

@export var faiblesse : String = "Aucune":
	set(value):
		faiblesse = value if value != "" else "Aucune"
		faiblesse = value if value.length() < 10 else value.substr(0, 10)

@export var resistance : String = "Aucune":
	set(value):
		resistance = value if value != "" else "Aucune"
		resistance = value if value.length() < 10 else value.substr(0, 10)

@export var color : Color

# Constructeur pour initialiser les valeurs directement
func _init(_nom = "Pas de nom", _faiblesse = "Aucune", _resistance = "Aucune", _color = Color(0.5, 0.5, 0.5)):
	nom = _nom
	faiblesse = _faiblesse
	resistance = _resistance
	color = _color
