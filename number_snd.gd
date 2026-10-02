extends Label
## Sprite "Number Display": mostra o valor de SND (só o número, em branco, fonte DonegalOne).

const FONTE := "res://fonts/DonegalOne-Regular.ttf"
const TAMANHO_FONTE := 24.0

@onready var palco = get_parent()


func _ready() -> void:
	# O Cenário está ampliado; desenhamos o texto já no tamanho final e reduzimos o nó,
	# senão a fonte é rasterizada pequena e fica borrada.
	var k: float = palco.scale.x
	scale = Vector2.ONE / k
	size *= k
	add_theme_font_size_override("font_size", roundi(TAMANHO_FONTE * k))
	add_theme_color_override("font_color", Color.WHITE)
	var fonte := load(FONTE)
	if fonte:
		add_theme_font_override("font", fonte)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	palco.faixa_mudou.connect(_atualizar)
	_atualizar(palco.snd)


func _atualizar(numero: int) -> void:
	text = str(numero)
