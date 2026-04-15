extends Resource
class_name Objet

@export var nom : String

@export var description : String

@export var capture : bool

@export var reanime : bool

@export var soigne : bool

@export_enum("0%", "25%", "50%", "75%", "100%")
var nbPvSoigne : String

# Constructeur pour initialiser les valeurs directement
func _init(_nom = "Pas de nom", _description = "Pas de description", _capture = false, _reanime = false, _soigne = false, _nbPvSoigne = "0%"):
	nom = _nom
	description = _description
	capture = _capture
	reanime = _reanime
	soigne = _soigne
	nbPvSoigne = _nbPvSoigne
