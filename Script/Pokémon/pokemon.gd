extends CharacterBody3D

# Valeur qui contient toutes les informations sur le pokemon
var data : PokemonData

# Fonction appellé au lancement du jeu
func _ready() -> void:
	
	if self.name == "PokemonJoueur":
		data = dataDuJeu.pokemonJoueurStats
	else:
		data = dataDuJeu.pokemonEnnemiStats
	
	_selectionSprite()
	
	print(data.nature.stat1)
	print(data.nature.modificateur1)
	print(data.nature.stat2)
	print(data.nature.modificateur2)
	print(data.pv)
	print(data.attaque)

# Fonction appellé à chaque frame
func _physics_process(delta: float) -> void:
	
	if data.xpObjectif <= data.xp:
		data._niveauSuperieur()

# Fonction qui attribue un sprite au pokémon selon son type
func _selectionSprite() -> void:
	
	match data.type:
		"Feu":
			$Sprite3D.texture = load("res://Assets/Pokemon/Bomjeton.png")
		"Plante":
			$Sprite3D.texture = load("res://Assets/Pokemon/Greupô.png")
		"Eau":
			$Sprite3D.texture = load("res://Assets/Pokemon/Sainjypleur.png")
