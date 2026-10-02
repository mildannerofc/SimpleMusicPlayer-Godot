extends Sprite2D
## Sprite "Fade": tela preta que some no começo.

signal terminou                       # equivale ao broadcast "Sound Test"

# O Scratch roda a 30 fps: "espere 0.07" na prática dura ~0.1 s e o "repita 10" (ghost +10) ~0.33 s.
@export var espera_inicial := 0.1
@export var duracao_fade := 0.33


func iniciar() -> void:
	show()
	z_index = 10                      # "vá para a camada da frente"
	modulate.a = 1.0                  # ghost = 0
	var tween := create_tween()
	tween.tween_interval(espera_inicial)
	tween.tween_property(self, "modulate:a", 0.0, duracao_fade)
	tween.tween_callback(_terminar)


func _terminar() -> void:
	hide()                            # "quando eu receber Sound Test -> esconda"
	terminou.emit()
