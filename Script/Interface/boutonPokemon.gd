extends TextureButton

var pokemon : PokemonData

static var boutonActif : TextureButton = null

var textStats1 : String = ""
var textStats2 : String = ""
var textDescription : String = ""
var textNature: String = ""

var couleur : Color
var sprite : Texture2D

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
		
		textStats1 = pokemon.nom + "\n" +"\n"
		textStats1 += "  " + str(pokemon.lvl)
		
		textStats2 = str(pokemon.attaque) + "\n" + "\n"
		textStats2 += str(pokemon.defense) + "\n" + "\n"
		textStats2 += str(pokemon.vitesse) 
		
		textNature = pokemon.nature.stat1 + pokemon.nature.modificateur1 + "\n" + pokemon.nature.stat2 + pokemon.nature.modificateur2 + "\n"
		
		textDescription = pokemon.description
		
		get_node("Label_Nom").text = pokemon.nom
		get_node("TextureRect_Pokemon").texture = sprite
		get_node("TextureRect_Pokemon").modulate = couleur 
		get_node("TextureProgressBar_PV").max_value = pokemon.pv
		get_node("TextureProgressBar_PV").value = pokemon.pv_Actuels
		get_node("Label_PV").text = str(pokemon.pv_Actuels) + "/" + str(pokemon.pv)

func _on_pressed() -> void:
	if boutonActif != null:
		boutonActif = null
		ecran_de_transition._fondu("InterfaceMenu/MenuPokemon/Resume")
	else:
		if pokemon != null:
			boutonActif = self
			
			ecran_de_transition._fondu("InterfaceMenu/MenuPokemon/Resume")
			get_parent().get_node("Resume/TextureRect_Pokemon").texture = boutonActif.sprite
			get_parent().get_node("Resume/Label_Stats1").text = boutonActif.textStats1
			get_parent().get_node("Resume/Label_Stats2").text = boutonActif.textStats2
			get_parent().get_node("Resume/TextureRect_Pokemon").modulate = boutonActif.couleur
			get_parent().get_node("Resume/Label_Description").text = boutonActif.textDescription
			get_parent().get_node("Resume/TextureProgressBar_PV").max_value = boutonActif.pokemon.pv
			get_parent().get_node("Resume/TextureProgressBar_PV").value = boutonActif.pokemon.pv_Actuels
			get_parent().get_node("Resume/Label_Nature").text = boutonActif.textNature
			get_parent().get_node("Resume/Label_PV").text = str(boutonActif.pokemon.pv_Actuels) + "/" + str(boutonActif.pokemon.pv)
