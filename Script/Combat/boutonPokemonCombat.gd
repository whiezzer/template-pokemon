extends TextureButton

var pokemon : PokemonData

var combat : Node3D

static var boutonActif : TextureButton = null

var couleur : Color
var sprite : Texture2D

func _ready() -> void:
	combat = get_tree().current_scene

func _physics_process(delta: float) -> void:
	if int(self.name.substr(self.name.length()-1, 1)) > dataDuJeu.listePokemonsJoueur.size():
		pokemon = null
		couleur = Color(1, 1, 1)
		self.visible = false
	else:
		pokemon = dataDuJeu.listePokemonsJoueur[int(self.name.substr(self.name.length()-1, 1))-1]
		self.visible = true
		
		if pokemon.sprite == null && pokemon.type != null :
			couleur = pokemon.type.color
			sprite = load("res://Assets/Pokemon/Neutre/NeutreFace.png")
		else:
			couleur = Color(1, 1, 1)
			sprite = pokemon.sprite
		
		get_node("Label").text = pokemon.nom
		get_node("TextureRect_Pokemon").texture = sprite
		get_node("TextureRect_Pokemon").modulate = couleur 
		get_node("TextureProgressBar_PV").max_value = pokemon.pv
		get_node("TextureProgressBar_PV").value = pokemon.pv_Actuels
		get_node("Label_PV").text = str(pokemon.pv_Actuels) + "/" + str(pokemon.pv)

func _on_pressed() -> void:
	if pokemon != null:
			boutonActif = self
			
			if boutonActif.pokemon.pv_Actuels <= 0 || boutonActif.pokemon == dataDuJeu.pokemonJoueurStats:
				boutonActif = null
				return
			
			get_parent().get_node("PopUp-Confirmation").visible = true

func _confirmer() -> void:
	
	get_parent().get_node("PopUp-Confirmation").visible = false
	get_parent().visible = false
	get_tree().current_scene.get_node("InterfaceCombat").visible = true
	
	if boutonActif.pokemon.pv_Actuels <= 0:
		return
	
	get_tree().current_scene.get_node("PokemonJoueur/Sprite3D").visible = false
	
	dataDuJeu.indexPokemonJoueurActif = int(boutonActif.name.substr(boutonActif.name.length()-1, 1))-1
	get_tree().current_scene.get_node("PokemonJoueur").initialise()
	combat.pokemonJoueur = dataDuJeu.pokemonJoueurStats
	
	combat.ecrire_texte(combat.message, "Vous lancez un " + boutonActif.pokemon.nom)
	
	get_tree().current_scene.get_node("PokemonJoueur/AnimatedSpriteAttaque").play("Intro_Lenotre")
	await get_tree().current_scene.get_node("PokemonJoueur/AnimatedSpriteAttaque").animation_finished
	
	get_tree().current_scene.get_node("PokemonJoueur/Sprite3D").visible = true
	
	combat.enCoursDeTour = false
	combat.tourDuJoueur = false
	
	await combat._tourAdverse()
	
	combat.tourDuJoueur = true
	boutonActif = null
	
	combat.ecrire_texte(combat.message, "Choisissez une action")

func _annuler() -> void:
	get_parent().get_node("PopUp-Confirmation").visible = false
	boutonActif = null
