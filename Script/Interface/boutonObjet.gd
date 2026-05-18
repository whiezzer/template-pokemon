extends TextureButton

var objet : ObjetInventaire

var textureObjet = TextureRect

var objetDescription : Label

var objetNom : Label

var appuyer : bool = false

static var boutonActif : TextureButton = null

func _ready() -> void:
	if objet != null and boutonActif == null:
		objetDescription = get_tree().current_scene.get_node("InterfaceMenu/MenuObjet/Label_Description")
		textureObjet = get_tree().current_scene.get_node("InterfaceMenu/MenuObjet/TextureRect_Objet")

func _physics_process(delta: float) -> void:
	objetNom.text = objet.objet.nom + " : " + str(objet.quantite)

func _on_mouse_entered() -> void:
	objetDescription.text = objet.objet.description
	textureObjet.texture = objet.objet.texture

func _on_mouse_exited() -> void:
	if boutonActif != null:
		textureObjet.texture = boutonActif.objet.objet.texture
		objetDescription.text = boutonActif.objet.objet.description
	else:
		textureObjet.texture = null
		objetDescription.text = ""


func _on_pressed() -> void:
	if boutonActif == self:
		boutonActif = null
	else:
		if objet != null:
			boutonActif = self
			textureObjet.texture = boutonActif.objet.objet.texture
			objetDescription.text = boutonActif.objet.objet.description
