# Auditoria documental — 2026-10-08

Baseline: `72699f0c2752d029d8e8c3b48420c18a70dbe2a1`; branch `main`; VERSION `0.3.0`; fonte: [árvore do commit](https://github.com/aloisiocosta-prof/night-heist-escape-phase/tree/72699f0c2752d029d8e8c3b48420c18a70dbe2a1).

| Objeto | Evidência consultada | Resultado |
|---|---|---|
| Issues abertas e fechadas | API `/issues?state=all&per_page=100` e busca `is:issue` | Nenhuma issue; a listagem direta contém somente o PR #1 |
| Sub-issues | Universo de issues vazio | Nenhuma sub-issue encontrada; sem pai a percorrer |
| Pull requests | Busca com estado `all` e leitura do PR #1 | Um PR aberto, cinco commits, cinco arquivos; não integrado |
| Conversa do PR | Corpo, diff e comentário `6059703371` | ABCD–Feynman, LaTeX, pesquisa/TCC e versionamento |
| Revisões e comentários inline | APIs `/pulls/1/reviews` e `/pulls/1/comments` | Listas vazias |

As consultas foram realizadas no repositório [night-heist-escape-phase](https://github.com/aloisiocosta-prof/night-heist-escape-phase), e o PR lido foi [#1](https://github.com/aloisiocosta-prof/night-heist-escape-phase/pull/1).

| Evidência do baseline | O que sustenta | Limite |
|---|---|---|
| `project.godot`, `export_presets.cfg` | Projeto Godot; presets Web/Android | Preset não comprova exportação executada |
| `scripts/mission.gd` | Duração 180 s, penalidade 8 s, cooldown 3 s; vitória exige saque e retorno | Leitura estática, sem execução nesta auditoria |
| `tests/run_tests.gd`, `tests/run_controls.gd` | Casos técnicos de regras e controles | Teste técnico não mede aprendizagem |
| `.github/workflows/build-deploy.yml` | CI previsto para regressões, exports e QA visual | Workflow presente não comprova CI verde atual |
| `docs/VALIDATION.md` | Relatos anteriores de validação técnica | Relatos não reexecutados nesta transformação |
| `assets/audio/LICENSE.txt`, licença Kenney | Licenças específicas de áudio | Não cobrem automaticamente todo o código e arte |
| Ausência de LICENSE na raiz | Licenciamento geral pendente | Repositório público não concede automaticamente licença open source |

As evidências técnicas acima são rastreáveis ao [baseline](https://github.com/aloisiocosta-prof/night-heist-escape-phase/tree/72699f0c2752d029d8e8c3b48420c18a70dbe2a1), sem participantes, notas, questionários ou resultados educacionais identificados nos arquivos auditados.

A proposta recupera os três documentos operacionais do PR #1 e os mantém com proveniência; o novo `latex/main.tex` especializa o modelo genérico em dossiê documental, sem merge ou fechamento automático do PR anterior ([PR #1](https://github.com/aloisiocosta-prof/night-heist-escape-phase/pull/1)).
