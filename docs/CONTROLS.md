# Controles e acessibilidade — 0.3.0

Menu inicial com Iniciar, Configurações e Como jogar; pausa com Continuar, Configurações e Menu inicial. Configurações abertas durante a missão pausam o relógio e o personagem.

| Dispositivo | Padrão | Configuração |
|---|---|---|
| Teclado | WASD/setas, Espaço, C, Shift, E, Esc, R | Remapeamento por ação; rejeita duplicatas; Esc cancela captura |
| Gamepad | Analógico esquerdo/D-pad, A salto, X ação, B agachar, LB correr, Start pausa | Remapeamento de botões; zona morta 0,10–0,50; analógico/D-pad fixos |
| Mouse | Esquerdo ação, direito salto; teclado movimenta | Remapeamento dos dois botões; menus clicáveis |
| Touch | Joystick de quatro direções + quatro botões de ação | Tamanho do joystick e opacidade; botões independentes permitem multitouch |

Modo Automático mostra touch quando DisplayServer detecta tela de toque; modo Touch força exibição. O perfil define dicas e visibilidade, sem bloquear os demais dispositivos. Teclado e gamepad usam navegação de foco nativa nos menus. ConfigFile salva localmente os ajustes; a exportação Web depende da persistência disponível no navegador. Áudio tem controles separados para música e efeitos. Reduzir animações remove transições do menu e flash de alarme; a animação funcional do personagem permanece.

O joystick libera suas ações ao soltar, pausar ou trocar de tela. Captura de comandos respeita o tipo de dispositivo selecionado. O mouse não implementa movimento por clique, pois o gameplay é de plataforma.

Fontes técnicas: Godot 4.4 InputMap, InputEventJoypadMotion, ConfigFile, Control, TouchScreenButton. Áudio de interface: Kenney Interface Sounds 1.0 (2020), CC0, licença original preservada em assets/audio/kenney/License.txt.
