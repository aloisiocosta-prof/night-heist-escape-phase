# Validação da versão 0.2.0

Ambiente: Godot 4.4.1 oficial, Linux; execução em 2026-10-06.

- Teste inicial rejeitou a cena técnica sem `start_run`: requisito de gameplay ausente.
- `godot --headless --path . --editor --import`: scripts e recursos importados sem erros.
- `godot --headless --path . --script tests/run_tests.gd`: passou. Cobre início/pausa/timeout, vitória sem/ com cofre, saque único, penalidade/cooldown, salto, bloqueio físico de porta, skill check correto/incorreto, três escadas, descida, câmeras após 0,5 s, laser versus agachamento, hack e carregamento dos sons.
- Renderização real em Godot Compatibility/OpenGL, Mesa llvmpipe + Xvfb: tela inicial, cenário e skill check capturados e inspecionados. A barra de arrombamento foi movida para CanvasLayer para aparecer sobre o cenário; teste de regressão verifica essa composição.
- Actions repete importação, testes de gameplay e smoke test antes das duas exportações; verifica assinatura do APK e publica hashes SHA-256. Consultar execução vinculada ao commit da versão para resultado do CI.

Os testes movem o personagem por física nativa em trechos e reposicionam entre cenários independentes; não representam playtest humano integral. A captura visual não comprova reprodução audível. Controles multitouch, áudio em aparelho, desempenho Android e diferentes navegadores ainda precisam de playtest real.

O ambiente de navegador remoto pode não disponibilizar WebGL 2; isso não substitui a validação nativa e não prova compatibilidade com todo dispositivo. APK é preview com assinatura debug.


# Validação 0.3.0

Godot 4.4.1: regressões do gameplay e controles (persistência, duplicatas, joystick, liberação e pausa) passaram localmente. O servidor headless não despacha ScreenTouch como o renderizador real; esse teste chama o callback nativo do joystick, e os exports de QA testam a rota completa de InputEvent.

Capturas locais renderizadas com OpenGL/Mesa: menu, configurações de teclado/gamepad/touch, gameplay touch, skill check e pausa. A instrumentação envia eventos de mouse às posições calculadas pelos próprios Control, remapeia teclado/gamepad e verifica estado/posição/relógio. Não usa comparação de screenshot para inferir sucesso. Os exports de QA são separados da distribuição normal, marcados por custom feature visual_qa.

CI exige Chromium com WebGL2 por SwiftShader e emulador Android API 29 x86_64; publica capturas e relatórios nos artefatos visual-web e visual-android. Os screenshots Android incluem o framebuffer real do emulador e a captura do viewport Godot. Testes não comprovam gamepad físico, multitouch em telefone, áudio audível ou desempenho de GPU real.
