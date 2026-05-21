extends CharacterBody3D

# Valeur qui contient toutes les informations sur le pokemon
var data : PokemonData

# Fonction appellé au lancement du jeu
func _ready() -> void:
	initialise()

# Fonction appellé à chaque frame
func _physics_process(delta: float) -> void:
	
	if data.pv_Actuels < 0:
		data.pv_Actuels = 0
	
	if data.xpObjectif <= data.xp:
		_niveauSuperieur()

# Fonction qui attribue un sprite au pokémon selon son type
func _selectionSprite() -> void:
	if self.name == "PokemonJoueur":
		if data.sprite_Dos != null:
			$Sprite3D.texture = data.sprite_Dos
			$Sprite3D.modulate = Color(1, 1, 1)
		else:
			var sprite = load("res://Assets/Pokemon/Neutre/NeutreDos.png") 
			$Sprite3D.texture = sprite
			$Sprite3D.modulate = data.type.color
	else:
		if data.sprite != null:
			$Sprite3D.texture = data.sprite
			Color(1, 1, 1)
		else:
			var sprite = load("res://Assets/Pokemon/Neutre/NeutreFace.png") 
			$Sprite3D.texture = sprite
			$Sprite3D.modulate = data.type.color

# Fonction qui attribue des stats aux pokemons selon leur nature
func _attribueStatsNature() -> void:
	match data.nature.stat1:
		"pv":
			data.pv += ceil(int(data.nature.modificateur1.substr(1, data.nature.modificateur1.length() - 2)) / 100.0 * data.pv)
		"attaque":
			data.attaque += ceil(int(data.nature.modificateur1.substr(1, data.nature.modificateur1.length() - 2)) / 100.0 * data.attaque)
		"defense":
			data.defense += ceil(int(data.nature.modificateur1.substr(1, data.nature.modificateur1.length() - 2)) / 100.0 * data.defense)
		"vitesse":
			data.vitesse += ceil(int(data.nature.modificateur1.substr(1, data.nature.modificateur1.length() - 2)) / 100.0 * data.vitesse)
	
	match data.nature.stat2:
		"pv":
			data.pv -= ceil(int(data.nature.modificateur2.substr(1, data.nature.modificateur2.length() - 2)) / 100.0 * data.pv)
		"attaque":
			data.attaque -= ceil(int(data.nature.modificateur2.substr(1, data.nature.modificateur2.length() - 2)) / 100.0 * data.attaque)
		"defense":
			data.defense -= ceil(int(data.nature.modificateur2.substr(1, data.nature.modificateur2.length() - 2)) / 100.0 * data.defense)
		"vitesse":
			data.vitesse -= ceil(int(data.nature.modificateur2.substr(1, data.nature.modificateur2.length() - 2)) / 100.0 * data.vitesse)
	
	data.pv_Actuels = data.pv

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
		data.listeAttaque[i].PP = data.listeAttaque[i].PP_max
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

# Fonction qui joue le crie du pokémon
func _play(son : AudioStream) -> void:
	$AudioStreamPlayer3D.stream = son
	$AudioStreamPlayer3D.playing = true

func initialise() -> void:
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
