# Night Heist: Escape Phase

MVP jogável de stealth/platformer 2D em Godot 4.4.1 e GDScript nativo, baseado no GDD versão 0.2.

## Jogar

[Versão Web](https://aloisiocosta-prof.github.io/night-heist-escape-phase/) · [Downloads Android / Releases](https://github.com/aloisiocosta-prof/night-heist-escape-phase/releases)

Invada quatro pavimentos, abra portas por skill checks, evite câmeras e lasers, use switches e terminal, saqueie o cofre e retorne ao spawn antes dos 180 segundos. Os alarmes descontam tempo. Cofre coletado sem retorno não vence.

Controles: A/D ou ←/→ mover; W/S ou ↑/↓ escadas; Espaço pular; Shift correr; C agachar; E interagir/confirmar; Esc pausa; R reiniciar. Botões touch aparecem na borda inferior. SOM alterna áudio.

## Desenvolvimento e testes

Abra `project.godot` em Godot 4.4.1. Renderizador Compatibility, sem addons. Arte e áudio originais; consulte [design](docs/DESIGN.md) e [assets](docs/ASSETS.md).

```bash
godot --headless --path . --editor --import
godot --headless --path . --script tests/run_tests.gd
godot --headless --path . --quit-after 60
```

Testes validam regras de vitória/timeout, penalidade de alarme, bloqueio físico das portas, skill checks, escadas, detecção das câmeras, crouch sob laser e terminal. Não substituem playtest Android em aparelho real.

## CI/CD

- PR: importação, regressões do gameplay, smoke test, Web e APK.
- Main: mesmas verificações + deploy GitHub Pages + Release da versão de VERSION, após QA visual. Incremente VERSION para cada publicação.
- Tag v*: Release de prévia com APK, Web ZIP e SHA256SUMS.
- Manual em main: marque Publish a preview release after builds pass para publicar a versão de `VERSION` após testes/builds.

Pages usa GitHub Actions. A exportação Web precisa de WebGL2. APK ARMv7/ARM64 com SDK 34 e Java 17; é assinado com certificado debug temporário para testes. Instalar builds assinados com certificados diferentes pode exigir desinstalar o anterior. Distribuição de produção requer keystore durável e version/code crescente; Google Play requer AAB e assinatura de produção.

O viewport 1280×720 preserva a proporção, orientado a landscape. A janela do navegador e o APK usam o mesmo gameplay. Configurações de tempo/penalidade não especificadas no GDD estão registradas no documento de design.

## Referências

- GDD Night Heist: Escape Phase V2, versão 0.2, documento fornecido pelo usuário.
- [Godot CharacterBody2D](https://docs.godotengine.org/en/4.4/classes/class_characterbody2d.html)
- [Godot AudioStreamWAV](https://docs.godotengine.org/en/4.4/classes/class_audiostreamwav.html)
- [Godot Web export](https://docs.godotengine.org/en/4.4/tutorials/export/exporting_for_web.html)
- [Godot Android export](https://docs.godotengine.org/en/4.4/tutorials/export/exporting_for_android.html)

## Versão 0.3.0 — menus e dispositivos

Menu inicial, ajuda e configurações persistentes. Remapeie teclado/gamepad/mouse, ajuste zona morta, tamanho/opacidade do joystick e volumes. Perfil automático ou escolhido manualmente; navegação de menus por foco. Consulte [controles](docs/CONTROLS.md). Personagem com dez poses, áudio CC0 da Kenney e efeitos de passos/escada; ícones Web e Android próprios.

CI executa também exports exclusivos de QA em Chromium/WebGL2 e Android API 29 x86_64. Artefatos `visual-web` e `visual-android` contêm capturas, relatórios e logs. Pages e Release dependem dessas verificações. A automação injeta eventos na interface nativa Godot e verifica mudanças de estado; não substitui teste físico de gamepad, multitouch em aparelho, desempenho ou escuta do áudio.
