extends CanvasLayer

var combat: bool = false

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	sprite.visible = false

func _changer_scene(chemin: String) -> void:
		get_tree().paused = true  
		sprite.visible = true
		sprite.play("TransitionTrouver")
		await sprite.animation_finished
		get_tree().paused = false
		get_tree().change_scene_to_file(chemin)
		sprite.play("TransitionEntree")
		await sprite.animation_finished
		sprite.visible = false
