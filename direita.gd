extends "res://botao.gd"
## Play2 -> SND + 1 (dá a volta em MaxPlay)


func _ready() -> void:
	clicado.connect(palco.proxima)
