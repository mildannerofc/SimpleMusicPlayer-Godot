extends Sprite2D

signal tocar_comecou
signal parou
signal faixa_mudou(numero: int)
signal loop_mudou(ligado: bool)
signal estado_mudou(tocando: bool)

const FAIXAS := [
	{"nome": "CAVE", "arquivo": "res://music/cave.wav"},
	{"nome": "GENOCIDE NIGHT REIMAGINED", "arquivo": "res://music/Genocide Night Reimagined.wav"},
	{"nome": "DCZ", "arquivo": "res://music/DCZ.wav"},
	{"nome": "CHAMPION ISLAND THEME (YM2612 COVER)", "arquivo": "res://music/Google Doodle - Champion Island Theme YM2612 Cover.ogg"},
	{"nome": "RED OPERATION", "arquivo": "res://music/Red Operation.mp3"},
]

@export var auto_play := false
@export var min_play := 1
@export var espera_autoplay := 0.22

var snd := 1
var max_play := FAIXAS.size()
var is_looping := false
var is_playing := false

var _player: AudioStreamPlayer
var _sons: Array = []


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	add_child(_player)
	_player.finished.connect(_ao_terminar_faixa)

	# Monitora se a janela mudar de tamanho para ajustar a posição em tempo real
	get_tree().root.size_changed.connect(_centralizar_na_tela)
	# Executa a primeira centralização ao iniciar
	_centralizar_na_tela()

	for faixa in FAIXAS:
		var arquivo: String = faixa["arquivo"]
		if ResourceLoader.exists(arquivo):
			_sons.append(load(arquivo))
		else:
			_sons.append(null)
			push_warning("Arquivo de áudio não encontrado: " + arquivo)

	snd = clampi(snd, min_play, max_play)

	var fade = get_node_or_null("Blackfadein")
	if fade:
		fade.terminou.connect(_ao_terminar_fade)
		fade.iniciar()


func nome_da_faixa(numero: int) -> String:
	return FAIXAS[clampi(numero, 1, FAIXAS.size()) - 1]["nome"]


# --- Função de Centralização Automática ---------------------------------------
func _centralizar_na_tela() -> void:
	# Obtém o tamanho atual da área de renderização do jogo
	var tamanho_da_tela = get_viewport_rect().size
	
	# Move este nó para o centro. Se os elementos internos foram desenhados
	# a partir do canto superior esquerdo do Scratch, subtraímos metade da largura original 
	# projetada (ex: se seu projeto original tinha 480x360 ou 640x480).
	# Caso os elementos já estejam agrupados corretamente, a linha abaixo resolve:
	global_position = tamanho_da_tela / 2
	
	# NOTA: Se os botões ficarem deslocados após aplicar o código acima, 
	# substitua a linha do 'global_position' por esta para compensar o desvio do Scratch:
	# global_position = (tamanho_da_tela / 2) - Vector2(240, 180) # Troque 240 e 180 por metade da sua resolução base


# --- ações chamadas pelos botões ---------------------------------------------

func tocar() -> void:
	_player.stop()
	_definir_tocando(true)
	tocar_comecou.emit()
	_tocar_faixa_atual()


func parar() -> void:
	_player.stop()
	_definir_tocando(false)
	parou.emit()


func proxima() -> void:
	snd = min_play if snd + 1 > max_play else snd + 1
	faixa_mudou.emit(snd)


func anterior() -> void:
	snd = max_play if snd - 1 < min_play else snd - 1
	faixa_mudou.emit(snd)


func alternar_loop() -> void:
	is_looping = not is_looping
	loop_mudou.emit(is_looping)


func _tocar_faixa_atual() -> void:
	var som = _sons[snd - 1]
	if som == null:
		push_warning("Faixa %d sem arquivo: %s" % [snd, FAIXAS[snd - 1]["arquivo"]])
		_definir_tocando(false)
		return
	_player.stream = som
	_player.play()


func _ao_terminar_faixa() -> void:
	if not is_playing:
		return
	if is_looping:
		_tocar_faixa_atual()
	else:
		_definir_tocando(false)


func _definir_tocando(valor: bool) -> void:
	if is_playing == valor:
		return
	is_playing = valor
	estado_mudou.emit(valor)


func _ao_terminar_fade() -> void:
	await get_tree().create_timer(espera_autoplay).timeout
	if auto_play:
		tocar()
