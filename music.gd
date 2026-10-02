extends Sprite2D
## Sprite "Music": a notinha anima enquanto a música toca.

const FANTASIAS := {
	"fantasia1": ["res://graficos/music/fantasia1.svg", Vector2(-206.5, 141.86)],
	"fantasia2": ["res://graficos/music/fantasia2.svg", Vector2(-200.71, 141.45)],
	"fantasia3": ["res://graficos/music/fantasia3.svg", Vector2(-209.16, 144.46)]
}
# "Animate": próxima, (espera 0.4), anterior, anterior, próxima... a partir da fantasia1
const ANIMACAO := ["fantasia3", "fantasia1", "fantasia2", "fantasia1"]
const INTERVALO := 0.4

@onready var palco = get_parent()

var _texturas := {}
var _tween: Tween


func _ready() -> void:
	for nome in FANTASIAS:
		_texturas[nome] = load(FANTASIAS[nome][0])
	palco.estado_mudou.connect(_ao_mudar_estado)
	_ao_mudar_estado(palco.is_playing)


func _ao_mudar_estado(tocando: bool) -> void:
	if _tween:
		_tween.kill()
	if tocando:
		_tween = create_tween().set_loops()
		for nome in ANIMACAO:
			_tween.tween_callback(_trocar.bind(nome))
			_tween.tween_interval(INTERVALO)
	else:
		_trocar("fantasia1")          # "Stop Animation" (no Scratch original a animação nem parava de verdade)


func _trocar(nome: String) -> void:
	texture = _texturas[nome]
	offset = FANTASIAS[nome][1]
