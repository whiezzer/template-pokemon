extends Resource
class_name NatureStat

@export_enum("pv", "attaque", "defense", "vitesse")
var stat1 : String = "pv":
	set(value):
		stat1 = value if value != null and value != "" else "attaque"

@export_enum("+100%", "+90%", "+80%", "+70%", "+60%", "+50%", "+40%", "+30%", "+20%", "+10%", "+0%")
var modificateur1 : String = "+0%":
	set(value):
		modificateur1 = value if value != null and value != "" else "+0%"

@export_enum("pv", "attaque", "defense", "vitesse")
var stat2 : String = "attaque":
	set(value):
		stat2 = value if value != null and value != "" else "attaque"

@export_enum("-100%", "-90%", "-80%", "-70%", "-60%", "-50%", "-40%", "-30%", "-20%", "-10%", "-0%")
var modificateur2 : String = "-0%":
	set(value):
		modificateur2 = value if value != null and value != "" else "-0%"

# Constructeur pour initialiser les valeurs directement
func _init(s1 = "pv", m1 = "+0%", s2 = "attaque", m2 = "-0%"):
	stat1 = s1
	modificateur1 = m1
	stat2 = s2
	modificateur2 = m2
