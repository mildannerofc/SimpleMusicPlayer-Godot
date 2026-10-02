extends Sprite2D
## "Stage" do projeto Scratch (Simple Music Player).
## Guarda as variáveis globais (SND, isPlaying?, isLooping?, MinPlay, MaxPlay, AutoPlay?),
## toca o áudio e avisa os outros nós por sinais (no lugar dos "broadcasts" do Scratch).

signal tocar_comecou                  # broadcast "playSnd"
signal parou                          # broadcast "stopSnd"
signal faixa_mudou(numero: int)       # broadcast "updateSnd"
signal loop_mudou(ligado: bool)       # variável isLooping?
signal estado_mudou(tocando: bool)    # variável isPlaying?

# Para adicionar uma música: coloque o arquivo na pasta music/ e acrescente uma linha aqui.
# MaxPlay passa a ser o tamanho desta lista (antes era 8 fixo, mas só havia 2 sons mapeados).
const FAIXAS := [
	{"nome": "CAVE", "arquivo": "res://music/cave.wav"},
	{"nome": "GENOCIDE NIGHT REIMAGINED", "arquivo": "res://music/Genocide Night Reimagined.wav"},
	{"nome": "DCZ", "arquivo": "res://music/DCZ.wav"},
	{"nome": "CHAMPION ISLAND THEME (YM2612 COVER)", "arquivo": "res://music/Google Doodle - Champion Island Theme YM2612 Cover.ogg"},
	{"nome": "RED OPERATION", "arquivo": "res://music/Red Operation.mp3"},
]

@export var auto_play := false        # AutoPlay?
@export var min_play := 1             # MinPlay
@export var espera_autoplay := 0.22   # "espere 0.22 seg" depois do fade

var snd := 1                          # SND
var max_play := FAIXAS.size()         # MaxPlay
var is_looping := false               # isLooping?
var is_playing := false               # isPlaying?

var _player: AudioStreamPlayer
var _sons: Array = []


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	add_child(_player)
	_player.finished.connect(_ao_terminar_faixa)

	for faixa in FAIXAS:
		var arquivo: String = faixa["arquivo"]
		if ResourceLoader.exists(arquivo):
			_sons.append(load(arquivo))
		else:
			_sons.append(null)
			push_warning("Arquivo de áudio não encontrado: " + arquivo)

	snd = clampi(snd, min_play, max_play)

	# Bandeira verde: o Fade roda e, quando termina, o Scratch envia "Sound Test".
	var fade = get_node_or_null("Blackfadein")
	if fade:
		fade.terminou.connect(_ao_terminar_fade)
		fade.iniciar()


func nome_da_faixa(numero: int) -> String:
	return FAIXAS[clampi(numero, 1, FAIXAS.size()) - 1]["nome"]


# --- ações chamadas pelos botões ---------------------------------------------

func tocar() -> void:                 # "quando eu receber playSnd"
	_player.stop()                    # "pare todos os sons"
	_definir_tocando(true)
	tocar_comecou.emit()
	_tocar_faixa_atual()


func parar() -> void:                 # "quando eu receber stopSnd"
	_player.stop()
	_definir_tocando(false)
	parou.emit()


func proxima() -> void:               # botão Play2 (seta direita)
	snd = min_play if snd + 1 > max_play else snd + 1
	faixa_mudou.emit(snd)


func anterior() -> void:              # botão Play3 (seta esquerda)
	snd = max_play if snd - 1 < min_play else snd - 1
	faixa_mudou.emit(snd)


func alternar_loop() -> void:         # botão Loop
	is_looping = not is_looping
	loop_mudou.emit(is_looping)


# --- internos ---------------------------------------------------------------

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
		_tocar_faixa_atual()          # relê SND: com loop ligado, trocar de faixa vale na próxima volta
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
