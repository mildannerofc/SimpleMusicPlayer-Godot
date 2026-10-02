extends Sprite2D
## Sprite "Title": flutua para cima e para baixo para sempre.
## No Scratch: 6 passos (+1 y) / 6 (-1) / 6 (-1) / 6 (+1), um passo por quadro a 30 fps = 0.2 s cada bloco.

const AMPLITUDE := 6.0
const TEMPO := 0.2


func _ready() -> void:
	var y0 := position.y
	var tween := create_tween().set_loops()
	tween.tween_property(self, "position:y", y0 - AMPLITUDE, TEMPO)   # sobe
	tween.tween_property(self, "position:y", y0, TEMPO)               # volta
	tween.tween_property(self, "position:y", y0 + AMPLITUDE, TEMPO)   # desce
	tween.tween_property(self, "position:y", y0, TEMPO)               # volta
