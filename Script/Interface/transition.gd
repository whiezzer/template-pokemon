extends CanvasLayer

var combat: bool = false

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	sprite.visible = false

func _changer_scene(chemin: String) -> void:
		get_tree().paused = true  
		sprite.speed_scale = 1.0
		sprite.visible = true
		sprite.play("TransitionTrouver")
		get_tree().current_scene.get_node("AudioMusique3D").stream = dataDuJeu.musiqueTransitionCombat
		get_tree().current_scene.get_node("AudioMusique3D").playing = true
		await sprite.animation_finished
		get_tree().paused = false
		get_tree().change_scene_to_file(chemin)
		sprite.play("TransitionEntree")
		await sprite.animation_finished
		sprite.visible = false

func _fondu(chemin: String, vitesse: float = 1.0) -> void:
	sprite.visible = true
	sprite.speed_scale = vitesse
	sprite.play("FonduIn")
	await sprite.animation_finished
	
	if get_tree().current_scene.get_node(chemin).visible:
		get_tree().current_scene.get_node(chemin).visible = false
	else:
		get_tree().current_scene.get_node(chemin).visible = true
	
	sprite.play("FonduOut")
	await sprite.animation_finished
	sprite.visible = false

func _fonduEnOuvertureAudio(audio: AudioStreamPlayer3D, duree: float = 2.0, musique: AudioStream = null):
	if musique != null:
		audio.stream = musique 
	
	audio.volume_db = -80
	audio.play()
	
	var tween = create_tween()
	
	tween.tween_property(
		audio,
		"volume_db",
		0,
		duree
	)

func _fonduEnFermetureAudio(audio: AudioStreamPlayer3D, duree: float = 2.0, musique: AudioStream = null):
	if musique != null:
		audio.stream = musique 
	
	var tween = create_tween()
	
	tween.tween_property(
		audio,
		"volume_db",
		-80,
		duree
	)
	
	await tween.finished
	
	audio.stop()
