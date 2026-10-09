# Dois documentos vigentes

O pedido vigente define apenas o modelo demonstrativo de artigo e o dossiê da pesquisa. O exemplo apresenta o estudo documental do Night Heist, com conteúdo científico e evidência piloto, enquanto a extração de normas e as explicações de apresentação ficam no dossiê.

| Documento | Entrada | Estrutura e apresentação |
|---|---|---|
| Artigo demonstrativo | `latex/demo.tex` | NBR 6022:2018 consultada adicionalmente; título, autoria, resumos, introdução, desenvolvimento, considerações finais e referências; fonte Times 12 e espaço simples |
| Dossiê de pesquisa | `latex/main.tex` | Organização acadêmica com capa, identificação, sumário, pesquisa, extração dos nove documentos, matriz de requisitos e referências; fonte Times 12 e espaço 1,5 |

A família Times e as margens 3/2 cm do artigo são decisões gráficas, não prescrições específicas da NBR 6022; o item 6.1 deixa o projeto gráfico ao editor e recomenda fonte 12 e espaço simples. Os dados editoriais não foram inventados e as classificações permanecem pendentes de revisão humana.

## Compilação

```bash
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build/demo latex/demo.tex
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build/academic latex/main.tex
python3 tools/check_academic.py
```

A CI gera somente os dois PDFs acima. Os arquivos anteriores são histórico de desenvolvimento e não constituem os entregáveis vigentes. `latex/demo/research-body.tex` contém o corpo científico, e `latex/dossier/` contém pesquisa, extração e referências do dossiê.

## Leitura das fontes

A leitura é documentada em `research/evidence/nine-pdf-reading.json`: oito PDFs ABNT privados foram reexaminados, e o nono documento foi lido pela edição pública IBGE de 1993, obtida no site do IBGE. Não se afirmou identidade binária dessa cópia com o arquivo privado.

A NBR 6022:2018, ausente do conjunto privado, foi lida no PDF público da UFRB: https://www2.ufrb.edu.br/bcet/images/NBR_6022-2018.pdf. A NBR 6023 do acervo é de 2018 corrigida em 2020; a confrontação integral com a edição 2025 permanece pendente, conforme identificação institucional da UFES.

Os PDFs privados não integram o repositório público. O corpus próprio fica identificado no método, sem itens bibliográficos utilizados para justificar o próprio estudo.
