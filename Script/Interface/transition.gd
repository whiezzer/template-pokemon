extends CanvasLayer

var combat: bool = false

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	sprite.visible = false

func _changer_scene(chemin: String) -> void:
		get_tree().paused = true  
		sprite.visible = true
		sprite.play("TransitionTrouver")
		get_tree().current_scene.get_node("AudioMusique3D").stream = preload("res://Assets/Son/Combat/son_TransitionCombat.wav")
		get_tree().current_scene.get_node("AudioMusique3D").playing = true
		await sprite.animation_finished
		get_tree().paused = false
		get_tree().change_scene_to_file(chemin)
		sprite.play("TransitionEntree")
		await sprite.animation_finished
		sprite.visible = false

func _fondu(chemin: String) -> void:
	sprite.visible = true
	sprite.play("FonduIn")
	await sprite.animation_finished
	
	if get_tree().current_scene.get_node(chemin).visible:
		get_tree().current_scene.get_node(chemin).visible = false
	else:
		get_tree().current_scene.get_node(chemin).visible = true
	
	sprite.play("FonduOut")
	await sprite.animation_finished
	sprite.visible = false
