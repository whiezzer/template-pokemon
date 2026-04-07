extends CharacterBody3D

@export_category("Paramètre du joueur")

# Modifier la valeur pour changer la vitesse du joueur
@export var vitesse = 4.0

# Modifier la valeur pour changer la vitesse du joueur
@export var position_initial = Vector3(0, 1, 0)

# Paramètre à ne pas toucher
var tailleDeLaTuile = 1
var pourcentageDeMouvementJusquALaProchaineTuile = 0.0
var direction = Vector3.ZERO
var estEnMouvement = false


func _physics_process(delta: float) -> void:
	if !estEnMouvement:
		_enAttenteDeCommande()
	else:
		_move(delta)


func _enAttenteDeCommande() -> void:

	if direction.z == 0:
		direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))

	if direction.x == 0:
		direction.z = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	if direction != Vector3.ZERO:
		position_initial = position
		estEnMouvement = true


func _move(delta: float) -> void:

	pourcentageDeMouvementJusquALaProchaineTuile += vitesse * delta

	if pourcentageDeMouvementJusquALaProchaineTuile >= 1.0:
		pourcentageDeMouvementJusquALaProchaineTuile = 0.0
		position = position_initial + (direction * tailleDeLaTuile)
		direction = Vector3.ZERO
		estEnMouvement = false
	else:
		position = position_initial + (direction * tailleDeLaTuile * pourcentageDeMouvementJusquALaProchaineTuile)
