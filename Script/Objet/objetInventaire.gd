class_name ObjetInventaire
extends Resource

@export var objet : Objet
@export var quantite : int = 0

# Constructeur pour initialiser les valeurs directement
func _init(_objet = Objet.new(), _quantite = 0):
	objet = _objet
	quantite = _quantite
