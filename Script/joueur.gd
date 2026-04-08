extends CharacterBody3D

@export_category("Paramètre du joueur")

# Modifier la valeur pour changer la vitesse du joueur (4.0 celle de base)
@export var vitesse = 4.0

# Modifier la valeur pour changer la position de départ du joueur ((0, 1, 0) celle de base)
@export var position_initial = Vector3(0, 1, 0)

# Paramètre à ne pas toucher
var tailleDeLaTuile = 1
var pourcentageDeMouvementJusquALaProchaineTuile = 0.0
var direction = Vector3.ZERO
var estEnMouvement = false

# Fonction appellé au lancement du jeu
func _ready() -> void:
	position = position_initial

# Fonction appellé à chaque frame
func _physics_process(delta: float) -> void:
	if !estEnMouvement:
		_enAttenteDeCommande()
	else:
		_movement(delta)

# Fonction qui gère si le joueur doit se déplacer ou pas,
# en fonction de si oui ou non des commandes de déplacement ont été pressé.
func _enAttenteDeCommande() -> void:
	if direction.z == 0:
		direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))

	if direction.x == 0:
		direction.z = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	if direction != Vector3.ZERO:
		position_initial = position
		estEnMouvement = true

# Fonction qui permet de déplacer le joueur
func _movement(delta: float) -> void:
	pourcentageDeMouvementJusquALaProchaineTuile += vitesse * delta

	if pourcentageDeMouvementJusquALaProchaineTuile >= 1.0:
		pourcentageDeMouvementJusquALaProchaineTuile = 0.0
		position = position_initial + (direction * tailleDeLaTuile)
		direction = Vector3.ZERO
		estEnMouvement = false
	else:
		position = position_initial + (direction * tailleDeLaTuile * pourcentageDeMouvementJusquALaProchaineTuile)
