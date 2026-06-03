@tool
class_name ObjetInventaire
extends Resource

@export var objet : Objet:
	set(value):
		objet = value if value != null else Objet.new("Pas de nom", null, "Pas de description", false, false, true)

@export var quantite : int = 0:
	set(value):
		quantite = max(value, 0)

# Constructeur pour initialiser les valeurs directement
func _init(_objet = Objet.new(), _quantite = 0):
	objet = _objet
	quantite = _quantite
