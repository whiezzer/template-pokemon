class_name PokemonData
extends Resource

var nom : String
var type : String
var faiblesse : String
var resistance : String
var pv : int
var pv_Actuels : int 
var attaque : int
var defense : int
var vitesse : int

var listeAttaque : Array[Attaque]

var lvl : int = 1
var xp : int = 0
var xpObjectif : int = 1000
var nature : NatureStat

# Fonction pour faire passer un pokémon au niveau suivant
func _niveauSuperieur() -> void:
	xp = xp - xpObjectif
	xpObjectif += xpObjectif / 2
	lvl += 1
	pv += randi_range(1, 5) 
	attaque += randi_range(1, 2) 
	defense += randi_range(1, 2) 
	vitesse += randi_range(1, 2) 
	
	_attribueStatsNature()

# Fonction qui attribue des attaques au pokémon selon son type
func _selectionAttaque() -> void:
	match type:
		"Feu":
			listeAttaque = [
				Attaque.new("Flamme", "Feu", 3, 20),
				Attaque.new("Flamme", "Feu", 3, 20),
				Attaque.new("Flamme", "Feu", 3, 20), 
				Attaque.new("Flamme", "Feu", 3, 20)
			]
			
			nom = "Bomjeton"
			
			
			faiblesse = "Eau"
			resistance = "Plante"
			
		"Plante":
			listeAttaque = [
				Attaque.new("Feuille Slash", "Plante", 3, 20),
				Attaque.new("Feuille Slash", "Plante", 3, 20),
				Attaque.new("Feuille Slash", "Plante", 3, 20),
				Attaque.new("Feuille Slash", "Plante", 3, 20)
			]
			
			nom = "Greupô"
			
			faiblesse = "Feu"
			resistance = "Eau"
			
		"Eau":
			listeAttaque = [
				Attaque.new("Grosse Goutte", "Eau", 3, 35),
				Attaque.new("Grosse Goutte", "Eau", 3, 35),
				Attaque.new("Grosse Goutte", "Eau", 3, 35),
				Attaque.new("Grosse Goutte", "Eau", 3, 35)
			]
			
			nom = "Sainjypleur"
			
			faiblesse = "Plante"
			resistance = "Feu"
			

# Fonction qui attribue des stats aux pokemons selon leur nature
func _attribueStatsNature() -> void:
	match nature.stat1:
		"pv":
			pv += ceil(int(nature.modificateur1.substr(1, nature.modificateur1.length() - 2)) / 100.0 * pv)
			pv_Actuels = pv
		"attaque":
			attaque += ceil(int(nature.modificateur1.substr(1, nature.modificateur1.length() - 2)) / 100.0 * attaque)
		"defense":
			defense += ceil(int(nature.modificateur1.substr(1, nature.modificateur1.length() - 2)) / 100.0 * defense)
		"vitesse":
			vitesse += ceil(int(nature.modificateur1.substr(1, nature.modificateur1.length() - 2)) / 100.0 * vitesse)
	
	match nature.stat2:
		"pv":
			pv -= ceil(int(nature.modificateur2.substr(1, nature.modificateur2.length() - 2)) / 100.0 * pv)
			pv_Actuels = pv
		"attaque":
			attaque -= ceil(int(nature.modificateur2.substr(1, nature.modificateur2.length() - 2)) / 100.0 * attaque)
		"defense":
			defense -= ceil(int(nature.modificateur2.substr(1, nature.modificateur2.length() - 2)) / 100.0 * defense)
		"vitesse":
			vitesse -= ceil(int(nature.modificateur2.substr(1, nature.modificateur2.length() - 2)) / 100.0 * vitesse)

# Constructeur pour initialiser les valeurs directement
func _init(_type = "Feu", _pv = 10, _attaque = 3, _def = 3, _vitesse = 3):
	type = _type
	pv = _pv
	pv_Actuels = _pv
	attaque = _attaque
	defense = _def
	vitesse = _vitesse
	
	_selectionAttaque()
	
	randomize()
	if nature == null:
		var indexNature = randi() % dataDuJeu.listeDesNatures.size()
		nature = dataDuJeu.listeDesNatures[indexNature]
	
	_attribueStatsNature()
