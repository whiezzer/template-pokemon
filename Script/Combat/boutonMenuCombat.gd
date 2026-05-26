extends TextureButton

var combat : Node3D

func _ready() -> void:
	combat = get_parent().get_parent()

func _on_menu_objet_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	if combat.tourDuJoueur == true && combat.enCoursDeTour == false:
		
		ecran_de_transition._fondu("InterfaceSac")

func _on_menu_pokemon_pressed() -> void:
	$AudioStreamPlayer2D.playing = true
	
	if combat.tourDuJoueur == true && combat.enCoursDeTour == false:
		
		ecran_de_transition._fondu("InterfacePokemon")
		dataDuJeu.objetUtilisé = null
