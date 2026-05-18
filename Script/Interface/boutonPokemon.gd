extends TextureButton

var pokemon : PokemonData

var appuyer : bool = false

static var boutonActif : TextureButton = null

var textStats1 : String = ""
var textStats2 : String = ""

func _physics_process(delta: float) -> void:
	if int(self.name.substr(self.name.length()-1, 1)) > dataDuJeu.listePokemonsJoueur.size():
		pokemon = null
		get_node("Label").text = ""
		get_parent().get_node("TextureRect_Pokemon").modulate = Color(1, 1, 1)
	else:
		pokemon = dataDuJeu.listePokemonsJoueur[int(self.name.substr(self.name.length()-1, 1))-1]
		get_node("Label").text = pokemon.nom
		if pokemon.sprite == load("res://Assets/Pokemon/Neutre/NeutreFace.png") && pokemon.type != null :
			get_parent().get_node("TextureRect_Pokemon").modulate = pokemon.type.color
		else:
			get_parent().get_node("TextureRect_Pokemon").modulate = Color(1, 1, 1)
		
		textStats1 = "Nom : " + pokemon.nom + "\n"
		#textStats1 += "Type : " + pokemon.type.nom + "\n"
		textStats1 += "PV : " + str(pokemon.pv_Actuels) + "/" + str(pokemon.pv) + "\n"
		textStats1 += "Atq : " + str(pokemon.attaque) + "\n"
		textStats1 += "Défense : " + str(pokemon.defense) + "\n"
		
		textStats2 = "Vitesse : "  + str(pokemon.vitesse) + "\n"
		#textStats2 += "Nature : " + "\n" + pokemon.nature.stat1 + pokemon.nature.modificateur1 + "\n" + pokemon.nature.stat2 + pokemon.nature.modificateur2 + "\n"

func _on_mouse_entered() -> void:
	if pokemon != null and boutonActif == null:
		get_parent().get_node("TextureRect_Pokemon").texture = pokemon.sprite
		get_parent().get_node("Label_Stats1").text = textStats1
		get_parent().get_node("Label_Stats2").text = textStats2


func _on_mouse_exited() -> void:
	if boutonActif != null:
		get_parent().get_node("TextureRect_Pokemon").texture = boutonActif.pokemon.sprite
		get_parent().get_node("Label_Stats1").text = textStats1
		get_parent().get_node("Label_Stats2").text = textStats2
	else:
		get_parent().get_node("TextureRect_Pokemon").texture = null
		get_parent().get_node("Label_Stats1").text = ""
		get_parent().get_node("Label_Stats2").text = ""


func _on_pressed() -> void:
	if boutonActif == self:
		boutonActif = null
	else:
		if pokemon != null:
			boutonActif = self
			get_parent().get_node("TextureRect_Pokemon").texture = boutonActif.pokemon.sprite
			get_parent().get_node("Label_Stats1").text = textStats1
			get_parent().get_node("Label_Stats2").text = textStats2
