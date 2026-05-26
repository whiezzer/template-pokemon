extends TextureButton

var pokemon : GodomonData

var combat : Node3D

static var boutonActif : TextureButton = null

var couleur : Color
var sprite : Texture2D

func _ready() -> void:
	combat = get_tree().current_scene

func _physics_process(delta: float) -> void:
	if int(self.name.substr(self.name.length()-1, 1)) > dataDuJeu.listeGodomonsJoueur.size():
		pokemon = null
		couleur = Color(1, 1, 1)
		self.visible = false
	else:
		pokemon = dataDuJeu.listeGodomonsJoueur[int(self.name.substr(self.name.length()-1, 1))-1]
		self.visible = true
		
		if pokemon.sprite == null && pokemon.type != null :
			couleur = pokemon.type.color
			sprite = load("res://Assets/Godomon/Neutre/NeutreFace.png")
		else:
			couleur = Color(1, 1, 1)
			sprite = pokemon.sprite
		
		get_node("Label").text = pokemon.nom
		get_node("TextureRect_Godomon").texture = sprite
		get_node("TextureRect_Godomon").modulate = couleur 
		get_node("TextureProgressBar_PV").max_value = pokemon.pv
		get_node("TextureProgressBar_PV").value = pokemon.pv_Actuels
		get_node("Label_PV").text = str(pokemon.pv_Actuels) + "/" + str(pokemon.pv)

func _on_pressed() -> void:
	if pokemon != null && dataDuJeu.objetUtilisé == null:
			boutonActif = self
			
			if boutonActif.pokemon.pv_Actuels <= 0 || boutonActif.pokemon == dataDuJeu.pokemonJoueurStats:
				boutonActif = null
				return
			
			get_parent().get_node("PopUp-Confirmation").visible = true
	elif pokemon != null && dataDuJeu.objetUtilisé.objet.reanime && pokemon.pv_Actuels <= 0:
		boutonActif = self
		get_parent().get_node("PopUp-Confirmation").visible = true
	
	elif pokemon != null && dataDuJeu.objetUtilisé.objet.soigne && pokemon.pv_Actuels > 0:
		boutonActif = self
		get_parent().get_node("PopUp-Confirmation").visible = true

func _confirmer() -> void:
	
	if dataDuJeu.objetUtilisé == null:
		_changer()
	elif dataDuJeu.objetUtilisé.objet.reanime:
		_reanime()
	elif dataDuJeu.objetUtilisé.objet.soigne:
		_soigne()

func _changer() -> void:
	
	get_parent().get_node("PopUp-Confirmation").visible = false
	get_parent().visible = false
	get_tree().current_scene.get_node("InterfaceCombat").visible = true
	
	if boutonActif.pokemon.pv_Actuels <= 0:
		return
	
	get_tree().current_scene.get_node("GodomonJoueur/Sprite3D").visible = false
	
	dataDuJeu.indexGodomonJoueurActif = int(boutonActif.name.substr(boutonActif.name.length()-1, 1))-1
	get_tree().current_scene.get_node("GodomonJoueur").initialise()
	combat.pokemonJoueur = dataDuJeu.pokemonJoueurStats
	
	combat.ecrire_texte(combat.message, "Vous lancez un/une " + boutonActif.pokemon.nom)
	
	get_tree().current_scene.get_node("GodomonJoueur/AnimatedSpriteAttaque").play("Intro_Lenotre")
	await get_tree().current_scene.get_node("GodomonJoueur/AnimatedSpriteAttaque").animation_finished
	
	get_tree().current_scene.get_node("GodomonJoueur/Sprite3D").visible = true
	
	combat.enCoursDeTour = false
	combat.tourDuJoueur = false
	
	await combat._tourAdverse()
	
	combat.tourDuJoueur = true
	boutonActif = null
	
	combat.ecrire_texte(combat.message, "Choisissez une action")

func _reanime() -> void:
	get_parent().get_node("PopUp-Confirmation").visible = false
	get_parent().visible = false
	get_tree().current_scene.get_node("InterfaceCombat").visible = true
	
	combat.ecrire_texte(combat.message, "Vous utilisez un/une " +dataDuJeu.objetUtilisé.objet.nom)
	
	await get_tree().create_timer(2.0).timeout
	
	combat.ecrire_texte(combat.message, "Vous réanimez " + boutonActif.pokemon.nom)
	
	boutonActif.pokemon.pv_Actuels = boutonActif.pokemon.pv * int(dataDuJeu.objetUtilisé.objet.nbPvSoigne.substr(0, dataDuJeu.objetUtilisé.objet.nbPvSoigne.length() - 1)) / 100
	
	combat.enCoursDeTour = false
	combat.tourDuJoueur = false
	
	await combat._tourAdverse()
	
	combat.tourDuJoueur = true
	boutonActif = null
	
	combat.ecrire_texte(combat.message, "Choisissez une action")
	
	dataDuJeu.objetUtilisé = null

func _soigne() -> void:
	get_parent().get_node("PopUp-Confirmation").visible = false
	get_parent().visible = false
	get_tree().current_scene.get_node("InterfaceCombat").visible = true
	
	dataDuJeu.objetUtilisé.quantite -= 1
	combat.enCoursDeTour = true
	
	combat.ecrire_texte(combat.message, "Vous utilisez un/une " +dataDuJeu.objetUtilisé.objet.nom)
	
	await get_tree().create_timer(2.0).timeout
	
	combat.ecrire_texte(combat.message, "Vous soignez " + boutonActif.pokemon.nom + " de " + str(boutonActif.pokemon.pv * int(dataDuJeu.objetUtilisé.objet.nbPvSoigne.substr(0, dataDuJeu.objetUtilisé.objet.nbPvSoigne.length() - 1)) / 100) + " points de vies")
	
	boutonActif.pokemon.pv_Actuels += boutonActif.pokemon.pv * int(dataDuJeu.objetUtilisé.objet.nbPvSoigne.substr(0, dataDuJeu.objetUtilisé.objet.nbPvSoigne.length() - 1)) / 100
	
	if boutonActif.pokemon.pv_Actuels > boutonActif.pokemon.pv:
		boutonActif.pokemon.pv_Actuels = boutonActif.pokemon.pv
	
	combat.enCoursDeTour = false
	combat.tourDuJoueur = false
	
	await combat._tourAdverse()
	
	combat.tourDuJoueur = true
	boutonActif = null
	
	combat.ecrire_texte(combat.message, "Choisissez une action")
	
	dataDuJeu.objetUtilisé = null

func _annuler() -> void:
	get_parent().get_node("PopUp-Confirmation").visible = false
	boutonActif = null
