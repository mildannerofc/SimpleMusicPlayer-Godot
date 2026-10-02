extends "res://botao.gd"
## Play3 -> SND - 1 (dá a volta em MinPlay)


func _ready() -> void:
	clicado.connect(palco.anterior)
