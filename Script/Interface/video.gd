extends VideoStreamPlayer

var slider: HSlider

func _enter_tree() -> void:
	if slider == null:
		slider = get_parent().get_node("Panel/HSlider")

func _physics_process(delta: float) -> void:
	if !self.paused:
		slider.value = self.stream_position

func _jouerVideo(lien: String) -> void:
	get_tree().current_scene.get_node("AudioMusique3D").stream_paused = true
	await ecran_de_transition._fondu("InterfaceTutoriel/PanelVideo")
	self.stream = load(lien)
	slider.max_value = self.get_stream_length()
	self.play()

func _drag_started() -> void:
	self.paused = true

func _drag_ended(value_changed: bool) -> void:
	if value_changed:
		self.stream_position = slider.value
	self.paused = false

func _pause() -> void:
	if self.paused:
		self.paused = false
	else:
		self.paused = true

func _on_video_return() -> void:
	await ecran_de_transition._fondu("InterfaceTutoriel/PanelVideo")
	get_tree().current_scene.get_node("AudioMusique3D").stream_paused = false
	self.stream = null
	self.paused = false
