extends CharacterBody3D

@export_category("Paramètre du joueur")

# Modifier la valeur pour changer la vitesse du joueur (4.0 celle de base)
@export var vitesse: float = 64.0

# Modifier la valeur pour changer la position de départ du joueur ((0, 1, 0) celle de base)
@export var position_initial: Vector3 = Vector3(0.0, 1.0, 1.0)

# Paramètre à ne pas toucher
var tailleDeLaTuile: float = 0.1
var pourcentageDeMouvementJusquALaProchaineTuile: float = 0.0
var direction: Vector2 = Vector2.ZERO
var estEnMouvement: bool = false
var animArbre 
var animEtat
var pause: bool = false
var bruitActif: bool = false

# Fonction appellé au lancement du jeu
func _ready() -> void:
	add_to_group("Joueur")
	if dataDuJeu.coordonésJoueurs == Vector3(99.0, 99.0, 99.0):
		position = position_initial
	else:
		position = dataDuJeu.coordonésJoueurs
	animArbre = $AnimationTree
	animEtat = animArbre.get("parameters/playback")
	animArbre.active = true

# Fonction appellé à chaque frame
func _physics_process(delta: float) -> void:
	if !estEnMouvement && !pause:
		_enAttenteDeCommande()
	elif direction != Vector2.ZERO:
		animEtat.travel("Walk")
		_movement(delta)
		dataDuJeu.coordonésJoueurs = self.position
	else:
		animEtat.travel("Idle")
	
	if dataDuJeu.menuPrincipalActif:
		pause = true

# Fonction qui gère si le joueur doit se déplacer ou pas,
# en fonction de si oui ou non des commandes de déplacement ont été pressé.
func _enAttenteDeCommande() -> void:
	if direction.y == 0:
		direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	if direction.x == 0:
		direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if direction != Vector2.ZERO:
		animArbre.set("parameters/Idle/blend_position", direction)
		animArbre.set("parameters/Walk/blend_position", direction)
		position_initial = position
		estEnMouvement = true
	else:
		animEtat.travel("Idle")

# Fonction qui permet de déplacer le joueur
func _movement(delta: float) -> void:
	pourcentageDeMouvementJusquALaProchaineTuile += vitesse * delta
	
	var cible = position_initial + (Vector3(direction.x, 0.0, direction.y) * tailleDeLaTuile)
	var nouvelle_position = position_initial + (cible - position_initial) * pourcentageDeMouvementJusquALaProchaineTuile
	
	var mouvement = nouvelle_position - position
	var collision = move_and_collide(mouvement)
	
	if collision:
		direction = Vector2.ZERO
		estEnMouvement = false
		pourcentageDeMouvementJusquALaProchaineTuile = 0.0
		return
	
	if pourcentageDeMouvementJusquALaProchaineTuile >= 1.0:
		_bruitDePas()
		pourcentageDeMouvementJusquALaProchaineTuile = 0.0
		position = cible
		direction = Vector2.ZERO
		estEnMouvement = false

#Fonction qui vérifie si le joueur appuie sur Échape ou pas afin d'ouvrir le menu du jeu
func _input(event):
	if event.is_action_pressed("ui_cancel") && !dataDuJeu.menuPrincipalActif :
		var menu = get_parent().get_node("InterfaceMenu")
		
		if menu.visible == false:
			pause = true
			ecran_de_transition._fondu("InterfaceMenu", 0.5)
			await ecran_de_transition._fonduEnFermetureAudio(get_tree().current_scene.get_node("AudioMusique3D"), 1.0, dataDuJeu.musiqueMenu)
			get_tree().current_scene.get_node("AudioMusique3D").play()
			ecran_de_transition._fonduEnOuvertureAudio(get_tree().current_scene.get_node("AudioMusique3D"), 1.0)
			
		else:
			ecran_de_transition._fondu("InterfaceMenu", 0.5)
			await ecran_de_transition._fonduEnFermetureAudio(get_tree().current_scene.get_node("AudioMusique3D"), 1.0, dataDuJeu.musiquePrincipal)
			get_tree().current_scene.get_node("AudioMusique3D").play()
			ecran_de_transition._fonduEnOuvertureAudio(get_tree().current_scene.get_node("AudioMusique3D"), 1.0)
			menu.get_node("MenuObjet").visible = false
			menu.get_node("MenuGodomon").visible = false
			menu.get_node("MenuGodomon/Resume").visible = false
			menu.get_node("MenuGodomon/TextureButton_Godomon6").boutonActif = null
			pause = false

func _bruitDePas() -> void:
	if bruitActif == true:
		return
	
	bruitActif = true
	$AudioStreamPlayer3D.stream = load("res://Assets/Son/environnement/Pas-" + str(randi_range(1, 5)) + ".wav")
	$AudioStreamPlayer3D.playing = true
	await $AudioStreamPlayer3D.finished
	bruitActif = false
