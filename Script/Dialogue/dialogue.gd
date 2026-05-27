@tool
extends ScrollContainer

var listeDesTextes : Dictionary[String, Dictionary]

func _ready() -> void:
	for PNJ in dataDuJeu.listePNJ:
		listeDesTextes[PNJ] = load("res://Script/Dialogue/" + PNJ + ".json").data
	
	for PNJ in get_children():
		var boutonPNJ = PNJ.get_parent().get_parent().get_node("HBoxContainer/" + PNJ.name)
		boutonPNJ.pressed.connect(func(): _changerPNJ(boutonPNJ))
		
		for bouton in PNJ.get_node("Boutons").get_children():
			bouton.pressed.connect(func(): _changerTexte(bouton))
		for texte in PNJ.get_node("Dialogues").get_children():
			var lines = listeDesTextes[PNJ.name][texte.name]["lines"]
			for index in range(lines.size()):
				_initialise_dialogue(PNJ.name, texte.name, lines[index], index)

func _initialise_dialogue(PNJ: String, texte: String, contenu: String, index: int) -> void:
	var ligne = LineEdit.new()
	ligne.name = "LineEdit" + str(index) 
	ligne.text = contenu                  
	ligne.add_theme_font_override("font", preload("res://Assets/Text/pixel_operator/PixelOperator.ttf"))
	ligne.add_theme_font_size_override("font_size", 45)
	get_node(PNJ + "/Dialogues/" + texte).add_child(ligne)
	get_node(PNJ + "/Dialogues/" + texte).move_child(get_node(PNJ + "/Dialogues/" + texte + "/Boutons"), get_node(PNJ + "/Dialogues/" + texte).get_child_count() - 1)
	ligne.size_flags_stretch_ratio = 0.1
	ligne.size_flags_vertical = Control.SIZE_EXPAND
	ligne.max_length = 50
	ligne.text_changed.connect(func(new_text): _modifierTexte(ligne.text, ligne))

func _modifierTexte(new_text: String, texte: LineEdit) -> void:
	
	listeDesTextes[texte.get_parent().get_parent().get_parent().name][texte.get_parent().name]["lines"][int(texte.name.substr(texte.name.length()-1))] = new_text
	
	_sauvegarder(texte.get_parent().get_parent().get_parent().name)

func _sauvegarder(PNJ: String) -> void:
	var file = FileAccess.open("res://Script/Dialogue/" + PNJ + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify(listeDesTextes[PNJ], "\t"))

func _changerTexte(bouton: Button) ->void:
	var PNJ = bouton.get_parent().get_parent()
	
	for texte in PNJ.get_node("Dialogues").get_children():
		if texte.name == bouton.name:
			texte.visible = true
		else:
			texte.visible = false

func _changerPNJ(bouton: Button) ->void:
	
	for PNJ in get_children():
		if PNJ.name == bouton.name:
			PNJ.visible = true
		else:
			PNJ.visible = false
