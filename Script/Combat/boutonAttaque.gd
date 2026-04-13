extends Node

func _on_button_pressed():
	var combat = get_node("/root/SceneDeCombat")
	if combat.tourDuJoueur == true:
		combat._tour(dataDuJeu.pokemonJoueurStats, dataDuJeu.pokemonEnnemiStats)
