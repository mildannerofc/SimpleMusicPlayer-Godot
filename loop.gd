extends "res://botao.gd"
## Sprite "Loop": alterna isLooping? ao clicar e troca a fantasia (ligado / desligado).

const FANTASIAS := {
	"ligado": ["res://graficos/botoes/loop_ligado.svg", Vector2(-0.67, -1.99)],
	"desligado": ["res://graficos/botoes/loop_desligado.svg", Vector2(-2.85, -5.42)],
}

var _texturas := {}


func _ready() -> void:
	for nome in FANTASIAS:
		_texturas[nome] = load(FANTASIAS[nome][0])
	clicado.connect(palco.alternar_loop)
	palco.loop_mudou.connect(_atualizar)
	_atualizar(palco.is_looping)


func _atualizar(ligado: bool) -> void:
	var nome := "ligado" if ligado else "desligado"
	texture = _texturas[nome]
	offset = FANTASIAS[nome][1]       # mantém o centro de rotação do Scratch
