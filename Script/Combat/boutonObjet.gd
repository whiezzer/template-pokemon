extends Button

var objet : ObjetInventaire

var combat : Node3D

func _ready() -> void:
	combat = get_parent().get_parent().get_parent()

func _physics_process(delta: float) -> void:
	self.text = objet.objet.nom + " : " + str(objet.quantite)

func _on_button_pressed() -> void:
	if objet == null || objet.quantite == 0:
		return
	
	combat.ecrire_texte(combat.message, "Vous utilisez un " + objet.objet.nom)
	await get_tree().create_timer(2.0).timeout
	
	if objet.objet.capture == true:
		combat.ecrire_texte(combat.message, "Vous tentez de capturer un " + dataDuJeu.pokemonEnnemiStats.nom + " sauvage")
	elif objet.objet.reanime == true:
		combat.ecrire_texte(combat.message, "Vous reanimez " + dataDuJeu.pokemonJoueurStats.nom)
	elif objet.objet.soigne == true:
		combat.ecrire_texte(combat.message, "Vous soignez " + dataDuJeu.pokemonJoueurStats.nom + " de " + str(dataDuJeu.pokemonJoueurStats.pv * int(objet.objet.nbPvSoigne.substr(0, objet.objet.nbPvSoigne.length() - 1)) / 100) + " points de vies")
		dataDuJeu.pokemonJoueurStats.pv_Actuels += dataDuJeu.pokemonJoueurStats.pv * int(objet.objet.nbPvSoigne.substr(0, objet.objet.nbPvSoigne.length() - 1)) / 100
		if dataDuJeu.pokemonJoueurStats.pv_Actuels > dataDuJeu.pokemonJoueurStats.pv:
			dataDuJeu.pokemonJoueurStats.pv_Actuels = dataDuJeu.pokemonJoueurStats.pv
	
	await get_tree().create_timer(2.0).timeout
	
	combat.enCoursDeTour = false
	combat.tourDuJoueur = false
	combat._tourAdverse()
	objet.quantite -= 1
