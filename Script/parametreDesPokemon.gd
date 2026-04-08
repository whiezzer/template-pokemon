@tool
extends Node3D

# Liste de base de 6 natures avec leurs valeurs par défaut
var listeNatureDeBase : Array[NatureStat] = [
	NatureStat.new("attaque", "+10%", "defense", "-10%"),
	NatureStat.new("defense", "+10%", "attaque", "-10%"),
	NatureStat.new("attaqueSpe", "+10%", "defenseSpe", "-10%"),
	NatureStat.new("defenseSpe", "+10%", "attaqueSpe", "-10%"),
	NatureStat.new("vitesse", "+10%", "pv", "-10%"),
	NatureStat.new("pv", "+10%", "vitesse", "-10%")
]

@export_category("Paramètres généraux de tous les Pokémon")
# Liste de toutes les natures possible svisible et modifiable dans l’inspecteur
@export var listeDesNatures : Array[NatureStat] = []:
	set(value):
		listeDesNatures = value
		_verifierNatures()

# Vérifie la liste et s'assure qu'elle contient toujours 6 natures
func _verifierNatures() -> void:
	if 5 == listeDesNatures.size():
		listeDesNatures.append(NatureStat.new())
	elif  5 > listeDesNatures.size():
		listeDesNatures.pop_at(0)
		for i in range(listeNatureDeBase.size()):
			listeDesNatures.append(listeNatureDeBase[i])
	else:
		for i in range(listeDesNatures.size()):
			if listeDesNatures[i] == null:
				listeDesNatures[i] = NatureStat.new()

# Appel automatique au démarrage pour s'assurer de la taille correcte
func _ready() -> void:
	_verifierNatures()
