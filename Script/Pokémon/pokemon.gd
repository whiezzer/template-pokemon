extends CharacterBody3D

# Valeur qui contient toutes les informations sur le pokemon
var data : PokemonData

# Fonction appellé au lancement du jeu
func _ready() -> void:
	
	if self.name == "PokemonJoueur":
		data = dataDuJeu.pokemonJoueurStats
	else:
		data = dataDuJeu.pokemonEnnemiStats
	
	if data.nature == null:
		var indexNature = randi() % dataDuJeu.listeDesNatures.size()
		data.nature = dataDuJeu.listeDesNatures[indexNature]
	
	if self.name == "PokemonEnnemi":
		if dataDuJeu.pokemonJoueurStats.lvl > 1:
			for lvl in range (2, dataDuJeu.pokemonJoueurStats.lvl + 1 + randi_range(-1, 1)):
				_niveauSuperieur()
	
	if data.listeAttaque.size() == 0:
		_attribueStatsNature()
		
		_selectionAttaque()
		
		_selectionSprite()

# Fonction appellé à chaque frame
func _physics_process(delta: float) -> void:
	
	if data.pv_Actuels < 0:
		data.pv_Actuels = 0
	
	if data.xpObjectif <= data.xp:
		_niveauSuperieur()

# Fonction qui attribue un sprite au pokémon selon son type
func _selectionSprite() -> void:
	
	match data.type.nom:
		"Feu":
			$Sprite3D.texture = load("res://Assets/Pokemon/Bomjeton.png")
		"Plante":
			$Sprite3D.texture = load("res://Assets/Pokemon/Greupô.png")
		"Eau":
			$Sprite3D.texture = load("res://Assets/Pokemon/Sainjypleur.png")

# Fonction qui attribue des stats aux pokemons selon leur nature
func _attribueStatsNature() -> void:
	match data.nature.stat1:
		"pv":
			data.pv += ceil(int(data.nature.modificateur1.substr(1, data.nature.modificateur1.length() - 2)) / 100.0 * data.pv)
			data.pv_Actuels = data.pv
		"attaque":
			data.attaque += ceil(int(data.nature.modificateur1.substr(1, data.nature.modificateur1.length() - 2)) / 100.0 * data.attaque)
		"defense":
			data.defense += ceil(int(data.nature.modificateur1.substr(1, data.nature.modificateur1.length() - 2)) / 100.0 * data.defense)
		"vitesse":
			data.vitesse += ceil(int(data.nature.modificateur1.substr(1, data.nature.modificateur1.length() - 2)) / 100.0 * data.vitesse)
	
	match data.nature.stat2:
		"pv":
			data.pv -= ceil(int(data.nature.modificateur2.substr(1, data.nature.modificateur2.length() - 2)) / 100.0 * data.pv)
			data.pv_Actuels = data.pv
		"attaque":
			data.attaque -= ceil(int(data.nature.modificateur2.substr(1, data.nature.modificateur2.length() - 2)) / 100.0 * data.attaque)
		"defense":
			data.defense -= ceil(int(data.nature.modificateur2.substr(1, data.nature.modificateur2.length() - 2)) / 100.0 * data.defense)
		"vitesse":
			data.vitesse -= ceil(int(data.nature.modificateur2.substr(1, data.nature.modificateur2.length() - 2)) / 100.0 * data.vitesse)

# Fonction qui attribue des attaques au pokémon selon son type
func _selectionAttaque() -> void:
	data._listeDesTypes = dataDuJeu.listeDesTypes
	
	var listeAttaqueDuMemeType = []
	
	for attaque in dataDuJeu.listeDesAttaques:
		if attaque.type == data.type.nom or attaque.type == "Normal":
			listeAttaqueDuMemeType.append(attaque)
	
	for i in range(4):
		var attaque = listeAttaqueDuMemeType.pick_random()
		data.listeAttaque.append(attaque.duplicate(true))
		data.listeAttaque[i]._listeDesTypes = attaque._listeDesTypes
		data.listeAttaque[i].type = attaque.type

# Fonction pour faire passer un pokémon au niveau suivant
func _niveauSuperieur() -> void:
	data.xp = data.xp - data.xpObjectif
	data.xpObjectif += data.xpObjectif / 2
	data.lvl += 1
	data.pv += randi_range(1, 5) 
	data.attaque += randi_range(1, 2) 
	data.defense += randi_range(1, 2) 
	data.vitesse += randi_range(1, 2) 
	
	_attribueStatsNature()
