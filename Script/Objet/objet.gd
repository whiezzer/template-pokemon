@tool
extends Resource
class_name Objet

@export var nom : String = "Pas de nom":
	set(value):
		var valide = value if value != "" else "Pas de nom"
		nom = valide if valide.length() < 15 else valide.substr(0, 15)

@export var texture : Texture2D:
	set(value):
			texture = value
			_verifierSprite()

@export var description : String = "Pas de description":
	set(value):
		var valide = value if value != "" else "Pas de description"
		description = valide if valide.length() < 500 else valide.substr(0, 500)

@export var capture : bool:
	set(value):
		if value == true:
			reanime = false
			soigne = false
		capture = value
		_verifierSprite()

@export var reanime : bool:
	set(value):
		if value == true:
			capture = false
			soigne = false
		reanime = value
		_verifierSprite()

@export var soigne : bool:
	set(value):
		if value == true:
			reanime = false
			capture = false
		soigne = value
		_verifierSprite()

@export_enum("0%", "25%", "50%", "75%", "100%")
var nbPvSoigne : String = "0%":
	set(value):
		nbPvSoigne = value if value != "" else "0%"

# Constructeur pour initialiser les valeurs directement
func _init(_nom = "Pas de nom", _texture = null, _description = "Pas de description", _capture = false, _reanime = false, _soigne = false, _nbPvSoigne = "0%"):
	nom = _nom
	texture = _texture
	description = _description
	capture = _capture
	reanime = _reanime
	soigne = _soigne
	nbPvSoigne = _nbPvSoigne

func _verifierSprite() -> void:
	if capture && Engine.is_editor_hint():
		texture = load("res://Assets/Objets/Godoballs/Pokeball attraper57.png")
		notify_property_list_changed()
