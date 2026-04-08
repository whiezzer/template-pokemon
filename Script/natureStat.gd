extends Resource
class_name NatureStat

@export_enum("pv", "attaque", "attaqueSpe", "defense", "defenseSpe", "vitesse")
var stat1 : String

@export_enum("+10%", "-10%", "0%")
var modificateur1 : String

@export_enum("pv", "attaque", "attaqueSpe", "defense", "defenseSpe", "vitesse")
var stat2 : String

@export_enum("+10%", "-10%", "0%")
var modificateur2 : String

# Constructeur pour initialiser les valeurs directement
func _init(s1 = "pv", m1 = "0%", s2 = "attaque", m2 = "0%"):
	stat1 = s1
	modificateur1 = m1
	stat2 = s2
	modificateur2 = m2
