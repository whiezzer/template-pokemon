extends Area3D

var dialogue: RichTextLabel
var menuDialogue: Control
var joueur: CharacterBody3D

var proche: bool = false
var enDialogue: bool = false

func _ready() -> void:
	dialogue = get_tree().current_scene.get_node("InterfaceDialogue/ZoneDeTexte")
	menuDialogue = get_tree().current_scene.get_node("InterfaceDialogue")
	joueur = get_tree().current_scene.get_node("Joueur")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") && proche && !enDialogue:
		enDialogue = true
		joueur.pause = true
		menuDialogue.visible = true
		await ecrire_texte(dialogue, "Bonjour, je m'appelle Nedy. Je suis le meilleur dresseur, le Roi parmi les rois !")
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
		await ecrire_texte(dialogue, "Ça te dirait de manger la pâtée du siècle ?")
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
		await ecrire_texte(dialogue, "C'est une question rhétorique en fait.")
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
		menuDialogue.visible = false
		await get_tree().create_timer(0.5).timeout
		_lancer_combat()

# Fonction appellé quand le joueur est en face du PNJ
func _onCollision(body) -> void:
	if proche:
		proche = false
	else:
		proche = true

# Fonction qui écrit un text petit à petit
func ecrire_texte(label: RichTextLabel, texte: String, vitesse := 0.03):
	label.text = texte
	label.visible_characters = 0
	
	while label.visible_characters < texte.length():
		label.visible_characters += 1
		await get_tree().create_timer(vitesse).timeout

# Fonction qui permet de lancer un combat
func _lancer_combat():
	if !is_inside_tree():
		return
	
	ecran_de_transition._changer_scene("res://Scene/SceneDeCombat.tscn")
