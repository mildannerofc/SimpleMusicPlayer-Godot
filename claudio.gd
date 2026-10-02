extends Sprite2D
## Sprite "Claudio": espera parado (ciclo lento) ou dança enquanto a música toca.
## Cada fantasia tem um offset próprio para reproduzir o centro de rotação do Scratch
## (sem isso o personagem "pula" de lado a cada quadro, porque as imagens têm larguras diferentes).

const FANTASIAS := {
	"Claudio2": ["res://claudio/Claudio2.svg", Vector2(-0.77, -0.52)],
	"Claudio3": ["res://claudio/Claudio3.svg", Vector2(-6.93, -0.64)],
	"Claudio4": ["res://claudio/Claudio4.svg", Vector2(-6.74, -0.64)],
	"Claudio5": ["res://claudio/Claudio5.svg", Vector2(-7.17, -0.64)],
	"Claudio6": ["res://claudio/Claudio6.svg", Vector2(-7.17, -0.64)],
	"Claudio7": ["res://claudio/Claudio7.svg", Vector2(-0.77, -0.52)],
	"Claudio8": ["res://claudio/Claudio8.svg", Vector2(-5.25, -0.52)]
}
const ESPERANDO := ["Claudio2", "Claudio7", "Claudio8", "Claudio7"]
const DANCANDO := ["Claudio3", "Claudio3", "Claudio4", "Claudio5", "Claudio6", "Claudio5", "Claudio4"]
const INTERVALO_ESPERANDO := 1.0
const INTERVALO_DANCANDO := 0.1       # o Scratch pede 0.07 s, mas a 30 fps isso vira ~0.1 s na tela

@export var enable_claudio := true:   # EnableClaudio
	set(valor):
		enable_claudio = valor
		visible = valor

@onready var palco = get_parent()

var _texturas := {}
var _tween: Tween


func _ready() -> void:
	for nome in FANTASIAS:
		_texturas[nome] = load(FANTASIAS[nome][0])
	visible = enable_claudio
	palco.estado_mudou.connect(_ao_mudar_estado)
	_ao_mudar_estado(palco.is_playing)


func _ao_mudar_estado(tocando: bool) -> void:
	if tocando:
		_iniciar_ciclo(DANCANDO, INTERVALO_DANCANDO)      # "quando eu receber claudio dançando"
	else:
		_iniciar_ciclo(ESPERANDO, INTERVALO_ESPERANDO)    # "quando eu receber claudio esperando"


func _iniciar_ciclo(sequencia: Array, intervalo: float) -> void:
	if _tween:
		_tween.kill()
	_trocar(sequencia[0])
	_tween = create_tween().set_loops()
	for nome in sequencia:
		_tween.tween_callback(_trocar.bind(nome))
		_tween.tween_interval(intervalo)


func _trocar(nome: String) -> void:
	texture = _texturas[nome]
	offset = FANTASIAS[nome][1]
