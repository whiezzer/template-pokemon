@tool
extends Node

var nom: String

var equipePokemon: Array[int] = []:
	set(value):
		if value == [] || value == null:
			equipePokemon = [0]
		elif value.size() > 6:
			equipePokemon = value.pop_at(equipePokemon.size()-1)
		else:
			equipePokemon = value

var _listePokemons: Array[PokemonData]

func _get_property_list():
	if _listePokemons.is_empty() and Engine.is_editor_hint():
		var scene_root = Engine.get_main_loop().edited_scene_root
		if scene_root:
			var param = scene_root.find_child("Paramètre", true, false)
			if param and param.get("listePokemons") != null:
				_listePokemons = param.get("listePokemons")

	var noms := _listePokemons.map(func(p): return p.nom)

	return [
		{
			"name": "equipePokemon",
			"type": TYPE_ARRAY,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": "%d/%d:%s" % [TYPE_INT, PROPERTY_HINT_ENUM, ",".join(noms)],
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_STORAGE
		}
	]

var gagner: bool

func _ready() -> void:
	nom = self.name
