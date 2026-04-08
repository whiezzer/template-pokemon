extends Area3D

@export_category("Paramètre des Hautes herbes")

# Probabilité de rencontrer un pokémon dans les hautes herbes en pourcentage
@export var probabiliteDeRencontre: float = 12.5

# Fonction appellé au lancement du jeu
func _ready() -> void:
	_maxPourcentage()
	_minPourcentage()
	randomize()

# Fonction appellé quand le joueur se déplace dans les hautes herbes
func _onCollision(body) -> void:
	var aleatoir = randf() * 100
	if aleatoir <= probabiliteDeRencontre:
		print("Lancement d'un combat")

# Fonction qui permet de ne pas dépasser le pourcentage max de probabilité de rencontre
func _maxPourcentage() -> void:
	if probabiliteDeRencontre > 100.0:
		probabiliteDeRencontre = 100.0

# Fonction qui permet de ne pas avoir une probabilité de rencontre négatif
func _minPourcentage() -> void:
	if probabiliteDeRencontre < 0.0:
		probabiliteDeRencontre = 0.0
