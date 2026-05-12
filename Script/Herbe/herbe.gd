extends Area3D

@export_category("Paramètre des Hautes herbes")

# Probabilité de rencontrer un pokémon dans les hautes herbes en pourcentage
static var probabiliteDeRencontre: float = 12.5
var indetectable: bool = true

# Fonction appellé au lancement du jeu
func _ready() -> void:
	_maxPourcentage()
	_minPourcentage()
	randomize()
	await get_tree().create_timer(1.5).timeout
	indetectable = false

# Fonction appellé quand le joueur se déplace dans les hautes herbes
func _onCollision(body) -> void:
	if !indetectable:
		$AudioStreamPlayer3D.stream = load("res://Assets/Son/environnement/PasHerbe-" + str(randi_range(1, 5)) + ".wav")
		$AudioStreamPlayer3D.playing = true
		var aleatoir = randf() * 100
		if aleatoir <= probabiliteDeRencontre:
			call_deferred("_lancer_combat")

# Fonction qui permet de ne pas dépasser le pourcentage max de probabilité de rencontre
func _maxPourcentage() -> void:
	if probabiliteDeRencontre > 100.0:
		probabiliteDeRencontre = 100.0

# Fonction qui permet de ne pas avoir une probabilité de rencontre négatif
func _minPourcentage() -> void:
	if probabiliteDeRencontre < 0.0:
		probabiliteDeRencontre = 0.0

# Fonction qui permet de lancer un combat
func _lancer_combat():
	if !is_inside_tree():
		return
	
	ecran_de_transition._changer_scene("res://Scene/SceneDeCombat.tscn")
