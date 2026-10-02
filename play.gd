extends "res://botao.gd"
## Play -> broadcast playSnd


func _ready() -> void:
	clicado.connect(palco.tocar)
