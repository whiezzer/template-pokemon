extends Node

var objet : ObjetInventaire

var textureObjet = TextureRect

var objetDescription : Label

var objetNom : Label

func _ready() -> void:
	objetDescription = get_tree().current_scene.get_node("InterfaceMenu/MenuObjet/Label_Description")
	textureObjet = get_tree().current_scene.get_node("InterfaceMenu/MenuObjet/TextureRect_Objet")

func _physics_process(delta: float) -> void:
	objetNom.text = objet.objet.nom + " : " + str(objet.quantite)

func _on_mouse_entered() -> void:
	objetDescription.text = objet.objet.description
	textureObjet.texture = objet.objet.texture
