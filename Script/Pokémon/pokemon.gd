extends CharacterBody3D

# Valeur qui contient toutes les informations sur le pokemon
var data : PokemonData

# Fonction appellé au lancement du jeu
func _ready() -> void:
	if self.name == "PokemonJoueur":
		data = dataDuJeu.pokemonJoueurStats
	else:
		data = dataDuJeu.pokemonEnnemiStats

# Fonction appellé à chaque frame
func _physics_process(delta: float) -> void:
	if data.xpObjectif <= data.xp:
		data._niveauSuperieur()
