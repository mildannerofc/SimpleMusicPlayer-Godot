extends "res://botao.gd"
## Stop -> broadcast stopSnd


func _ready() -> void:
	clicado.connect(palco.parar)
