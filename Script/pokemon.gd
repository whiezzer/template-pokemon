extends CharacterBody3D

@export_category("Paramètre du Pokémon")

# Modifier la valeur pour changer le type du pokémon
@export_enum("Feu", "Eau", "Plante")
var type : String

# Modifier la valeur pour changer les points de vie max du pokémon (valeur de base est égale à 10)
@export var pv = 10

# Modifier la valeur pour changer l'attaque max du pokémon (valeur de base est égale à 10)
@export var attaque = 10

# Modifier la valeur pour changer l'attqua spéciale max du pokémon (valeur de base est égale à 10)
@export var attaqueSpe = 10

# Modifier la valeur pour changer la défense max du pokémon (valeur de base est égale à 10)
@export var defense = 10

# Modifier la valeur pour changer la défense spéciale max du pokémon (valeur de base est égale à 10)
@export var defenseSpe = 10

# Modifier la valeur pour changer la vitesse max du pokémon (valeur de base est égale à 10)
@export var vitesse = 10

# Paramètre à ne pas toucher
var lvl = 1
var nature = ""
var talent = ""

func _ready() -> void:
	randomize()
