extends Sprite2D
## Base dos botões clicáveis. Equivale ao padrão do Scratch:
## "tocando o ponteiro do mouse + mouse pressionado -> espere soltar -> se ainda tocando, faça a ação".

signal clicado

@onready var palco = get_parent()     # o Cenário (simplemusplay.gd)

var _apertado := false


func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton) or event.button_index != MOUSE_BUTTON_LEFT:
		return
	if event.pressed:
		_apertado = _mouse_em_cima()
	else:
		if _apertado and _mouse_em_cima():
			clicado.emit()
		_apertado = false


func _mouse_em_cima() -> bool:
	# get_global_mouse_position() + to_local() respeitam a escala/posição do Cenário
	# (o código antigo usava event.position, que está em coordenadas da janela e errava o clique).
	return is_visible_in_tree() and get_rect().has_point(to_local(get_global_mouse_position()))
