extends TextureButton

var pokemon : PokemonData

var combat : Node3D

var appuyer : bool = false

static var boutonActif : TextureButton = null

var textStats1 : String = ""
var textStats2 : String = ""
var textDescription : String = ""

var couleur : Color
var sprite : Texture2D

func _ready() -> void:
	combat = get_tree().current_scene

func _physics_process(delta: float) -> void:
	if int(self.name.substr(self.name.length()-1, 1)) > dataDuJeu.listePokemonsJoueur.size():
		pokemon = null
		get_node("Label").text = ""
		couleur = Color(1, 1, 1)
	else:
		pokemon = dataDuJeu.listePokemonsJoueur[int(self.name.substr(self.name.length()-1, 1))-1]
		get_node("Label").text = pokemon.nom
		if pokemon.sprite == null && pokemon.type != null :
			couleur = pokemon.type.color
			sprite = load("res://Assets/Pokemon/Neutre/NeutreFace.png")
		else:
			couleur = Color(1, 1, 1)
			sprite = pokemon.sprite
		
		textStats1 = "Nom : " + pokemon.nom + "\n"
		textStats1 += "Type : " + pokemon.type.nom + "\n"
		textStats1 += "PV : " + str(pokemon.pv_Actuels) + "/" + str(pokemon.pv) + "\n"
		textStats1 += "Atq : " + str(pokemon.attaque) + "\n"
		textStats1 += "Défense : " + str(pokemon.defense) + "\n"
		
		textStats2 = "Vitesse : "  + str(pokemon.vitesse) + "\n"
		textStats2 += "Nature : " + "\n" + pokemon.nature.stat1 + pokemon.nature.modificateur1 + "\n" + pokemon.nature.stat2 + pokemon.nature.modificateur2 + "\n"
		
		textDescription = pokemon.description

func _on_mouse_entered() -> void:
	if pokemon != null and boutonActif == null:
		get_parent().get_node("TextureRect_Pokemon").texture = sprite
		get_parent().get_node("Label_Stats1").text = textStats1
		get_parent().get_node("Label_Stats2").text = textStats2
		get_parent().get_node("TextureRect_Pokemon").modulate = couleur
		get_parent().get_node("Label_Description").text = textDescription

func _on_mouse_exited() -> void:
	if boutonActif == null:
		get_parent().get_node("TextureRect_Pokemon").texture = null
		get_parent().get_node("Label_Stats1").text = ""
		get_parent().get_node("Label_Stats2").text = ""
		get_parent().get_node("TextureRect_Pokemon").modulate = Color(1, 1, 1)
		get_parent().get_node("Label_Description").text = ""

func _on_pressed() -> void:
	if pokemon != null:
			boutonActif = self
			
			if boutonActif.pokemon.pv_Actuels <= 0 || boutonActif.pokemon == dataDuJeu.pokemonJoueurStats:
				boutonActif = null
				return
			
			get_parent().get_node("TextureRect_Pokemon").texture = boutonActif.sprite
			get_parent().get_node("Label_Stats1").text = boutonActif.textStats1
			get_parent().get_node("Label_Stats2").text = boutonActif.textStats2
			get_parent().get_node("TextureRect_Pokemon").modulate = boutonActif.couleur
			get_parent().get_node("Label_Description").text = boutonActif.textDescription
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
