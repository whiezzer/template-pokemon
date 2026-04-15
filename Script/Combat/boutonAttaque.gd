extends Button

var attaque: Attaque

func _ready() -> void:
	match self.name:
		"Bouton-Attaque1":
			attaque = dataDuJeu.pokemonJoueurStats.listeAttaque[0]
		"Bouton-Attaque2":
			attaque = dataDuJeu.pokemonJoueurStats.listeAttaque[1]
		"Bouton-Attaque3":
			attaque = dataDuJeu.pokemonJoueurStats.listeAttaque[2]
		"Bouton-Attaque4":
			attaque = dataDuJeu.pokemonJoueurStats.listeAttaque[3]

func _on_button_pressed() -> void:
	var combat = get_node("/root/SceneDeCombat")
	if combat.tourDuJoueur == true:
		combat._tourJoueur(attaque)
