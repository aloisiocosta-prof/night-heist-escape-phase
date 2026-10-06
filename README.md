# Night Heist: Escape Phase

Esqueleto Godot 4.4.1 em GDScript nativo, baseado no GDD versão 0.2 fornecido. A cena inicial contém apresentação e botão touch; o gameplay está pendente em [BACKLOG](docs/BACKLOG.md).

## Desenvolvimento

Abra `project.godot` com Godot 4.4.1 e execute F6/F5. Use o renderizador Compatibility. Versão fixada para reprodutibilidade, sem alegação de ser a versão mais recente.

## CI/CD

- Pull requests: importação, smoke test headless e exportações Web/APK.
- Push em main: mesmas verificações e deploy Web no GitHub Pages.
- Tags `v*`: mesmos builds; GitHub Release de prévia com APK debug assinado, ZIP Web e SHA-256.
- Execução manual: builds; deploy apenas se a referência selecionada for main.

Antes do primeiro deploy, em Settings → Pages → Build and deployment selecione **GitHub Actions**. O workflow requer Actions habilitado e permissão de publicação Pages; a criação de Releases usa `contents: write` apenas no job correspondente.

Web: single-thread, WebGL 2/Compatibility; não é Flutter/WasmGC. Android: APK ARMv7/ARM64, OpenJDK 17, SDK 34. Preview utiliza certificado debug gerado em cada execução; reinstalações entre builds podem exigir desinstalar a versão anterior. Para distribuição de produção, configure keystore durável protegido, use export-release e defina version/code crescente. O APK atual é para testes e não publicação Google Play.

## Criar e publicar no GitHub

Com GitHub CLI autenticado, dentro desta pasta:

```bash
git init -b main
git add .
git commit -m "Initialize Godot project and Android/Web CI/CD"
gh repo create aloisiocosta-prof/night-heist-escape-phase --public --source=. --remote=origin --push
```

Habilite Pages conforme acima e execute novamente o workflow se o primeiro deploy ocorreu antes dessa configuração. Após verificar os jobs, publique uma versão:

```bash
git tag v0.1.0
git push origin v0.1.0
```

Não há build/deploy remoto validado até executar o workflow no repositório real.

## Referências técnicas

- Godot Engine. Exporting for Web, versão 4.4: https://docs.godotengine.org/en/4.4/tutorials/export/exporting_for_web.html
- Godot Engine. Exporting for Android, versão 4.4: https://docs.godotengine.org/en/4.4/tutorials/export/exporting_for_android.html
- GitHub. Custom workflows with GitHub Pages: https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages

O GDD é a especificação do produto; as fontes técnicas documentam as exportações e a implantação, não constituem evidência acadêmica.
