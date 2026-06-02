extends VideoStreamPlayer

func _jouerVideo(lien: String) -> void:
	self.stream = load(lien)
	self.play()
