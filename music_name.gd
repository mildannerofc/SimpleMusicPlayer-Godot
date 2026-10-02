extends Label
## Sprite "Music Name": nome da faixa, entra deslizando da direita ao abrir.
## Os SVGs originais usavam <text>, que o Godot não desenha, então viraram um Label com a fonte DonegalOne.

const FONTE := "res://fonts/DonegalOne-Regular.ttf"
const TAMANHO_FONTE := 20.7           # 22 * 0.94124 do SVG original

@export var deslocamento_inicial := 480.0   # o Scratch começa em x=386 e vai a x=19
@export var duracao_entrada := 0.85         # jgTween: sine / out / 0.85 s

@onready var palco = get_parent()

var _x_final := 0.0
var _tween: Tween


func _ready() -> void:
	var k: float = palco.scale.x
	scale = Vector2.ONE / k
	size *= k
	add_theme_font_size_override("font_size", roundi(TAMANHO_FONTE * k))
	add_theme_color_override("font_color", Color.WHITE)
	var fonte := load(FONTE)
	if fonte:
		add_theme_font_override("font", fonte)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	palco.faixa_mudou.connect(_atualizar)  # "quando eu receber updateSnd"
	palco.parou.connect(_ao_parar)         # "quando eu receber stopSnd"
	_atualizar(palco.snd)

	_x_final = position.x
	position.x = _x_final + deslocamento_inicial
	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "position:x", _x_final, duracao_entrada)


func _atualizar(numero: int) -> void:
	text = palco.nome_da_faixa(numero)


func _ao_parar() -> void:
	if _tween:
		_tween.kill()                      # "pare os outros scripts do ator"
	position.x = _x_final
	_atualizar(palco.snd)
