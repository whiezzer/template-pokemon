extends VideoStreamPlayer

var slider: HSlider
var sliderAudio: VSlider
var pause: TextureButton
var modificationSon: bool = false

func _enter_tree() -> void:
	if slider == null:
		slider = get_parent().get_node("Panel/HSlider")
	if sliderAudio == null:
		sliderAudio = get_parent().get_node("Panel/TextureButton3/VSlider")
	if pause == null:
		pause = get_parent().get_node("Panel/TextureButton")

func _physics_process(delta: float) -> void:
	if !self.paused:
		slider.value = self.stream_position
	if modificationSon:
		self.volume = sliderAudio.value

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
	pause.texture_normal = load("res://Assets/Interface/PourVideo/Pause2.png")

func _drag_started_audio() -> void:
	modificationSon = true

func _drag_ended_audio() -> void:
	modificationSon = false

func _pause() -> void:
	if self.paused:
		self.paused = false
		pause.texture_normal = load("res://Assets/Interface/PourVideo/Pause2.png")
	else:
		self.paused = true
		pause.texture_normal = load("res://Assets/Interface/PourVideo/Pause1.png")

func _volume() -> void:
	if sliderAudio.visible:
		sliderAudio.visible = false
	else:
		sliderAudio.visible = true

func _on_video_return() -> void:
	await ecran_de_transition._fondu("InterfaceTutoriel/PanelVideo")
	get_tree().current_scene.get_node("AudioMusique3D").stream_paused = false
	self.stream = null
	self.paused = false
	sliderAudio.visible = false
	pause.texture_normal = load("res://Assets/Interface/PourVideo/Pause2.png")
