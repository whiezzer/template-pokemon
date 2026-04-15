extends Node
class_name Attaque

var nom : String

var type : String

var puissance : int

var PP : int

var PP_max : int

var precision : float

# Constructeur pour initialiser les valeurs directement
func _init(_nom, _type, _puissance, _PP_max, _precision = 0.8):
	nom = _nom
	type = _type
	puissance = _puissance
	PP = _PP_max
	PP_max = _PP_max
	precision = _precision
