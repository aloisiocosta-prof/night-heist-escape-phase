# Direção de arte e áudio

Paleta extraída do GDD §5: estrutura #4A4D52, cone #EAB308, laser #EF4444, madeira #8B5A2B. Azul noturno, ciano e verde complementam a legibilidade.

## Pixel art

`assets/characters/thief.svg`: spritesheet original com seis slots exatos 32×32. Pivô compartilhado, paleta fixa, fundo transparente, desenho composto por retângulos inteiros. Estados: idle, três quadros de corrida, salto/subida e crouch. Sprite2D usa hframes=6 e nearest filtering; poses são selecionadas pela física. Crouch comprime o corpo visual e reduz o collider, sem atravessar portas.

Ambiente desenhado por operações nativas CanvasItem: quatro pavimentos, janelas, escadas, cofre, portas, switches, câmeras e emissores. Iluminação dos cones é indicativa e coincide com a geometria usada para detecção. O cenário usa formas estilizadas; não é um tileset comercial de pixel art.

`assets/ui/*.svg`: oito ícones originais para controles touch 72×56, com contraste, área de toque e feedback verde.

## Áudio

Oito arquivos WAV mono originais: jump, switch, unlock, loot, alarm, win, fail e infiltration. PCM 16 bits / 22050 Hz; envelopes curtos evitam cliques. A música repete uma sequência minimalista de baixo para infiltração. Nenhuma gravação de terceiros ou música comercial.

Regeneração nativa:

```bash
godot --headless --path . --script tools/export_audio.gd
```

`HeistSound` usa AudioStreamWAV e pool de AudioStreamPlayer; mute disponível no HUD. Reprodução começa somente após ação do jogador, respeitando a restrição de autoplay dos navegadores. Amostras e parâmetros de síntese são registrados em `scripts/sound.gd`.

## Proveniência

Todo sprite, ícone, geometria e áudio foi criado no código deste repositório. Sem dependências de assets externos, sem download de conteúdo proprietário e sem exigência de plugins. As skills instaladas orientaram o processo; não foram adicionadas novas skills porque a especificação e as APIs nativas foram suficientes.

Fontes: GDD fornecido §5–6; documentação Godot 4.4 sobre sprites, importação de imagens e AudioStreamWAV.
