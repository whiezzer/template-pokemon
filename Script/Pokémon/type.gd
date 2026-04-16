extends Resource
class_name Type

@export var nom : String:
	set(value):
		nom = value if value != "" else "Normal"

@export var faiblesse : String:
	set(value):
		faiblesse = value if value != "" else "Aucune"

@export var resistance : String:
	set(value):
		resistance = value if value != "" else "Aucune"

# Constructeur pour initialiser les valeurs directement
func _init(_nom = "Normal", _faiblesse = "Aucune", _resistance = "Aucune"):
	nom = _nom
	faiblesse = _faiblesse
	resistance = _resistance
