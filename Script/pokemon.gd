extends CharacterBody3D

@export_category("Paramètre du Pokémon")

# Modifier la valeur pour changer le type du pokémon
@export_enum("Feu", "Eau", "Plante")
var type : String = "Feu"

# Modifier la valeur pour changer le nom du pokémon
@export var nom: String = "Pikachu" 

# Modifier la valeur pour changer les points de vie max du pokémon (valeur de base est égale à 10)
@export var pv: int = 10

# Modifier la valeur pour changer l'attaque max du pokémon (valeur de base est égale à 10)
@export var attaque: int = 10

# Modifier la valeur pour changer l'attqua spéciale max du pokémon (valeur de base est égale à 10)
@export var attaqueSpe: int = 10

# Modifier la valeur pour changer la défense max du pokémon (valeur de base est égale à 10)
@export var defense: int = 10

# Modifier la valeur pour changer la défense spéciale max du pokémon (valeur de base est égale à 10)
@export var defenseSpe: int = 10

# Modifier la valeur pour changer la vitesse max du pokémon (valeur de base est égale à 10)
@export var vitesse: int = 10

# Paramètre à ne pas toucher
var lvl: int = 1
var nature: NatureStat
var xp: int = 0
var xpObjectif: int = 1000

# Fonction appellé au lancement du jeu
func _ready() -> void:
	randomize()
	var indexNature = randi() % get_node("/root/Map/Paramètre").listeDesNatures.size()
	nature = get_node("/root/Map/Paramètre").listeDesNatures[indexNature]

# Fonction appellé à chaque frame
func _physics_process(delta: float) -> void:
	xp += 1
	if xpObjectif <= xp:
		_niveauSuperieur()

# Fonction pour faire passer un pokémon au niveau suivant
func _niveauSuperieur() -> void:
	xp = xp - xpObjectif
	xpObjectif += 100
	lvl += 1
	pv += randi() % 10
	attaque += randi() % 5
	defense += randi() % 5
	attaqueSpe += randi() % 5
	defenseSpe += randi() % 5
	vitesse += randi() % 5
	print(nom + " a gangé un niveau il passe niveau : " + str(lvl))
	print(pv)
	print(attaque)
	print(attaqueSpe)
	print(defense)
	print(defenseSpe)
	print(vitesse)
