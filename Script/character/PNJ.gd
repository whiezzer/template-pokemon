extends Area3D

var dialogue: RichTextLabel
var menuDialogue: Control
var joueur: CharacterBody3D
var conteneur: HBoxContainer

var proche: bool = false
var enDialogue: bool = false
var gagner: bool

var textes: Dictionary 
var line_index: int = 0
var current_id: String

func _ready() -> void:
	dialogue = get_tree().current_scene.get_node("InterfaceDialogue/ZoneDeTexte")
	menuDialogue = get_tree().current_scene.get_node("InterfaceDialogue")
	joueur = get_tree().current_scene.get_node("Joueur")
	textes = load("res://Script/Dialogue/" + get_parent().name + ".json").data
	conteneur = get_tree().current_scene.get_node("InterfaceDialogue/Choix/HBoxContainer")
	_choisitID("intro")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") && proche && !enDialogue:
		menuDialogue.visible = true
		enDialogue = true
		joueur.pause = true
		_lireTexte()

# Fonction qui permet d'afficher les dialogues d'un personnage
func _lireTexte() -> void:
	var node = textes[current_id]
	
	if line_index < node["lines"].size():
		await _ecrireTexte(dialogue, node["lines"][line_index])
		line_index += 1
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame
		_lireTexte()
	else:
		_lireChoix()

# Fonction qui permet d'afficher les différents choix de dialogue du joueur
func _lireChoix() -> void:
	var node = textes[current_id]
	var boutonID = 0
	
	if node.has("choices"):
		for c in node["choices"]:
			creer_bouton(boutonID, c["text"])
			boutonID += 1
	elif current_id == "combat":
		_lancer_combat()
	else:
		menuDialogue.visible = false
		joueur.pause = false
		await get_tree().create_timer(1.0).timeout
		enDialogue = false
		_choisitID("dejaParle")
		line_index = 0

# Fonction qui permet au joueur de choisir une réponse
func _choisir(choix_index: int) -> void:
	var node = textes[current_id]
	current_id = node["choices"][choix_index]["next"]
	line_index = 0
	for child in conteneur.get_children():
		child.queue_free()
	_lireTexte()

# Fonction qui écrit un text petit à petit
func _ecrireTexte(label: RichTextLabel, texte: String, vitesse := 0.03):
	label.text = texte
	label.visible_characters = 0
	
	while label.visible_characters < texte.length():
		label.visible_characters += 1
		await get_tree().create_timer(vitesse).timeout

# Fonction appellé quand le joueur est en face du PNJ
func _onCollision(body) -> void:
	if proche:
		proche = false
	else:
		proche = true

# Fonction qui permet de lancer un combat
func _lancer_combat():
	if !is_inside_tree():
		return
	
	for index in get_parent().equipePokemon:
		dataDuJeu.listePokemonsEnnemie.append(dataDuJeu.listePokemons[index].duplicate(true))
	
	dataDuJeu.adversaire = get_parent().name
	
	ecran_de_transition._changer_scene("res://Scene/SceneDeCombat.tscn")

# Fonction qui crée un bouton
func creer_bouton(index: int, text: String) -> void:
	var button = Button.new()
	button.text = text
	button.add_theme_color_override("font_color", Color.BLACK)
	button.add_theme_font_size_override("font_size", 30)
	button.add_theme_font_override("font", preload("res://Assets/Text/pixel_operator/PixelOperator.ttf"))
	var style = StyleBoxTexture.new()
	style.texture = preload("res://Assets/Interface/Combat/Bouton attaque normal.png")
	button.add_theme_stylebox_override("normal", style)
	button.pressed.connect(_choisir.bind(index))
	button.custom_minimum_size.x = 250
	button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	conteneur.add_child(button)

# Fonction qui choisit l'ID du texte à utiliser
func _choisitID(value: String) -> void:
	if dataDuJeu.listeDesDresseurs.has(get_parent().name):
		if dataDuJeu.listeDesDresseurs[get_parent().name] == false:
			current_id = "victoire"
		else:
			current_id = "defaite"
	else:
		current_id = value
