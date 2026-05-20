extends TextureButton

var pokemon : PokemonData

var appuyer : bool = false

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
		
		textStats1 = pokemon.nom + "\n" +"\n"
		textStats1 += "  " + str(pokemon.lvl)
		
		textStats2 = str(pokemon.attaque) + "\n" + "\n"
		textStats2 += str(pokemon.defense) + "\n" + "\n"
		textStats2 += str(pokemon.vitesse) 
		
		textNature = pokemon.nature.stat1 + pokemon.nature.modificateur1 + "\n" + pokemon.nature.stat2 + pokemon.nature.modificateur2 + "\n"
		
		textDescription = pokemon.description

func _on_mouse_entered() -> void:
	if pokemon != null and boutonActif == null:
		return

func _on_mouse_exited() -> void:
	if boutonActif != null:
		return
	else:
		return

func _on_pressed() -> void:
	if boutonActif == self:
		boutonActif = null
		get_parent().get_node("Resume").visible = false
	else:
		if pokemon != null:
			boutonActif = self
			get_parent().get_node("Resume").visible = true
			get_parent().get_node("Resume/TextureRect_Pokemon").texture = boutonActif.sprite
			get_parent().get_node("Resume/Label_Stats1").text = boutonActif.textStats1
			get_parent().get_node("Resume/Label_Stats2").text = boutonActif.textStats2
			get_parent().get_node("Resume/TextureRect_Pokemon").modulate = boutonActif.couleur
			get_parent().get_node("Resume/Label_Description").text = boutonActif.textDescription
			get_parent().get_node("Resume/TextureProgressBar").max_value = boutonActif.pokemon.pv
			get_parent().get_node("Resume/TextureProgressBar").value = boutonActif.pokemon.pv_Actuels
			get_parent().get_node("Resume/Label_Nature").text = boutonActif.textNature
