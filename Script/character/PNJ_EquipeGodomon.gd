@tool
extends CharacterBody3D

var equipeGodomon: Array[int] = []:
	set(value):
		if value == [] || value == null:
			equipeGodomon = [0]
		elif value.size() > 6:
			equipeGodomon = value.pop_at(equipeGodomon.size()-1)
		else:
			equipeGodomon = value

var _listeGodomons: Array[GodomonData]

func _get_property_list():
	if _listeGodomons.is_empty() and Engine.is_editor_hint():
		var scene_root = Engine.get_main_loop().edited_scene_root
		if scene_root:
			var param = scene_root.find_child("Paramètre", true, false)
			if param and param.get("listeGodomons") != null:
				_listeGodomons = param.get("listeGodomons")

	var noms := _listeGodomons.map(func(p): return p.nom)

	return [
		{
			"name": "equipeGodomon",
			"type": TYPE_ARRAY,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": "%d/%d:%s" % [TYPE_INT, PROPERTY_HINT_ENUM, ",".join(noms)],
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_STORAGE
		}
	]
