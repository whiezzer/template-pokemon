@tool
extends EditorPlugin

var editeur : Panel

const EDITEUR_DE_TEXTE = preload("uid://csn2bgmqgxjeb")


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	editeur = EDITEUR_DE_TEXTE.instantiate()
	
	add_control_to_dock(DOCK_SLOT_BOTTOM, editeur)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_docks(editeur)
	
	editeur.queue_free()
