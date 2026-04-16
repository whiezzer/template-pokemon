extends Resource
class_name Objet

@export var nom : String:
	set(value):
		nom = value if value != "" else "Pas de nom"
		nom = value if value.length() < 15 else value.substr(0, 15)

@export var description : String:
	set(value):
		description = value if value != "" else "Pas de description"
		description = value if value.length() < 500 else value.substr(0, 500)

@export var capture : bool

@export var reanime : bool

@export var soigne : bool

@export_enum("0%", "25%", "50%", "75%", "100%")
var nbPvSoigne : String:
	set(value):
		nbPvSoigne = value if value != "" else "0%"

# Constructeur pour initialiser les valeurs directement
func _init(_nom = "Pas de nom", _description = "Pas de description", _capture = false, _reanime = false, _soigne = false, _nbPvSoigne = "0%"):
	nom = _nom
	description = _description
	capture = _capture
	reanime = _reanime
	soigne = _soigne
	nbPvSoigne = _nbPvSoigne
