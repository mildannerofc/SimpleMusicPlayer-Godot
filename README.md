# Simple Music Player

Um player de música simples feito no **Godot 4.7**, portado de um projeto do PenguinMod/Scratch (`Simple_Music_Player.pmp`).

Tem botões de play, stop, loop, troca de faixa (anterior/próxima), o nome da música que entra deslizando e o Claudio, que espera parado ou dança enquanto a música toca.

## Recursos

- Play, stop e loop (liga/desliga com troca de ícone)
- Setas para trocar de faixa, dando a volta no início e no fim da lista
- Nome da faixa animado e ícone de nota que se mexe enquanto toca
- Personagem Claudio com dois ciclos de animação (esperando e dançando)
- Fade de entrada e título flutuante
- Reprodução automática opcional (`auto_play`)

## Como rodar

1. Instale o [Godot 4.7](https://godotengine.org/download) (ou compatível).
2. Clone o repositório:
   ```bash
   git clone https://github.com/SEU_USUARIO/simple-music-player.git
   ```
3. Abra o Godot, clique em **Importar** e selecione o `project.godot`.
4. Na primeira abertura o Godot importa os arquivos, o que leva alguns segundos.
5. Aperte **F5** para rodar. A cena principal é `playmus.tscn`.

Se preferir pelo terminal (com o `godot` no PATH), os scripts do `package.json` fazem o mesmo:

```bash
npm run start    # roda o projeto
npm run editor   # abre no editor
npm run import   # só importa os recursos (útil em CI)
```

O `package.json` existe só para esses atalhos. O projeto não tem dependências do npm.

## Controles

| Botão | Ação |
|---|---|
| ▶ Play | Toca a faixa atual |
| ■ Stop | Para a música |
| 🔁 Loop | Repete a faixa quando ela termina |
| ◀ / ▶ (setas) | Faixa anterior / próxima |

## Adicionando músicas

1. Coloque o arquivo (`.wav`, `.ogg` ou `.mp3`) na pasta `music/`.
2. Acrescente uma linha na lista `FAIXAS` do `simplemusplay.gd`:
   ```gdscript
   {"nome": "MINHA MUSICA", "arquivo": "res://music/minha_musica.ogg"},
   ```

O número máximo de faixas (`MaxPlay`) acompanha o tamanho da lista automaticamente.

## Estrutura

```
playmus.tscn          cena principal
simplemusplay.gd      estado, áudio e sinais (o "Stage" do Scratch)
botao.gd              base dos botões clicáveis
play.gd / stop.gd     botões play e stop
esquerda.gd / direita.gd   setas de troca de faixa
loop.gd               botão de loop
music.gd              nota musical animada
music_name.gd         nome da faixa
number_snd.gd         número da faixa
claudio.gd            personagem Claudio
texto.gd              título flutuante
blackfadein.gd        fade de entrada
graficos/  claudio/  musplay/  fonts/  music/   recursos
```

Os "broadcasts" do Scratch viraram sinais do Godot, emitidos pelo `simplemusplay.gd`: `tocar_comecou`, `parou`, `faixa_mudou`, `loop_mudou` e `estado_mudou`.

## Créditos

- Projeto original em Scratch/PenguinMod: Simple Music Player
- Fonte: Donegal One
- Músicas: confira a autoria e a licença de cada faixa em `music/` antes de redistribuir

## Licença

Defina aqui a licença do projeto (por exemplo, MIT) e adicione um arquivo `LICENSE`.
