extends Node

func _ready() -> void:
	if dataDuJeu.menuPrincipalActif:
		_lancerMenu()
	else:
		get_tree().current_scene.get_node("AudioMusique3D").stream = dataDuJeu.musiquePrincipal
		get_tree().current_scene.get_node("AudioMusique3D").play()

func _physics_process(delta: float) -> void:
	if !dataDuJeu.menuPrincipalActif:
		self.visible = false

func _lancerMenu() -> void:
	get_tree().current_scene.get_node("AudioMusique3D").stream = dataDuJeu.musiqueMenu
	get_tree().current_scene.get_node("AudioMusique3D").play()
	await get_node("AnimatedSprite2D").animation_finished
	get_node("AnimatedSprite2D").play("MainMenu")

# Fonction qui lance le jeu quand le joueur appuie sur entré dans le menu principal 
func _input(event):
	if event.is_action_pressed("ui_accept") && dataDuJeu.menuPrincipalActif :
		ecran_de_transition._fondu("InterfaceMenuPrincipal", 0.5)
		await ecran_de_transition._fonduEnFermetureAudio(get_tree().current_scene.get_node("AudioMusique3D"), 1.0)
		get_tree().current_scene.get_node("AudioMusique3D").stream = load("res://Assets/Son/environnement/musique_Environnement.mp3") 
		get_tree().current_scene.get_node("AudioMusique3D").play()
		ecran_de_transition._fonduEnOuvertureAudio(get_tree().current_scene.get_node("AudioMusique3D"), 1.0)
		dataDuJeu.menuPrincipalActif = false
		get_tree().current_scene.get_node("Joueur").pause = false
