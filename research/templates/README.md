# Modelo demonstrativo LaTeX de artigo

O modelo é uma composição própria em `article`, informada pelo exemplo canônico de artigo do abnTeX2 e pelos requisitos efetivamente lidos nos PDFs privados; não é um template oficial de periódico ou certificação de conformidade integral ([abnTeX2, modelo de 2018](https://github.com/abntex/abntex2/blob/master/doc/latex/abntex2/examples/abntex2-modelo-artigo.tex); [auditoria](../evidence/standards-audit.md)).

## Modelos e componentes encontrados

| Opção | Fonte primária | Avaliação em 8 out. 2026 |
|---|---|---|
| abnTeX2, modelo canônico de artigo | [GitHub](https://github.com/abntex/abntex2/blob/master/doc/latex/abntex2/examples/abntex2-modelo-artigo.tex), [CTAN](https://ctan.org/pkg/abntex2) | Referência estrutural para artigo; distribuição 1.9.7 de 2018, anterior a atualizações de 2021–2025 |
| Modelo canônico no Overleaf | [Galeria](https://www.overleaf.com/latex/templates/modelo-canonico-de-artigo-cientifico-com-abntex2/bycmpjrpdxnr) | A cópia consultada ainda menciona NBR 6022:2003; a data de indexação da página não atualiza o conteúdo normativo |
| biblatex-abnt | [CTAN](https://ctan.org/pkg/biblatex-abnt) | Componente bibliográfico, não template completo; versão 4.0 e copyright 2016–2017 não demonstram atualização automática às normas 2023/2025 |
| Composição própria deste projeto | `latex/style-abnt.tex`, `latex/demo.tex` | Implementa requisitos verificados, evita dependência da classe antiga e registra limites; referências da demonstração usam natbib e registros conferidos manualmente |

As edições atuais identificadas pela UFES incluem NBR 6022:2018, 6028:2021, 10520:2023, 14724:2024 e 6023:2025; uma atualização no editor ou pacote não substitui a conferência normativa ([UFES, página de normalização consultada em 2026](https://biblioteca.ufes.br/normalizacao)).

## Organização dos arquivos

| Arquivo/pasta | Função |
|---|---|
| `latex/style-abnt.tex` | Apresentação compartilhada: A4, fonte 12, margens 3/2 cm e entrelinhas 1,5 por adaptação de trabalho acadêmico |
| `latex/article.tex` | Entrada do manuscrito científico, preservado em conteúdo e reorganizado |
| `latex/article-metadata.tex` | Identificação e comandos de citação do manuscrito |
| `latex/sections/` | Seções separadas do artigo: resumo, introdução, fundamentação, método, resultados, discussão, limitações, conclusão e declarações |
| `latex/demo.tex` | Entrada da demonstração editorial |
| `latex/demo/` | Metadados, resumos, seções demonstrativas e referências autor-data |

A escolha de separar arquivos facilita a edição sem confundir apresentação, evidência e metadados; o artigo científico continua fundamentado na matriz piloto, e a demonstração apenas reutiliza três exemplos existentes, sem gerar resultados de aprendizagem ([protocolo](../protocol.md); [matriz](../instruments/fidelity.csv)).

## Compilação

Execute a partir da raiz do projeto; no Overleaf, importe o ZIP e selecione `latex/demo.tex` como documento principal ([abnTeX2, exemplo de estrutura LaTeX](https://github.com/abntex/abntex2/blob/master/doc/latex/abntex2/examples/abntex2-modelo-artigo.tex)).

```bash
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build/demo latex/demo.tex
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build/article latex/article.tex
python3 tools/check_academic.py
```

Dependências: pdfLaTeX, latexmk, babel, lmodern, geometry, hyperref, booktabs, longtable, array, setspace, microtype, indentfirst e natbib; os comandos efetivamente usados estão em [style-abnt.tex](../../latex/style-abnt.tex) e [demo.tex](../../latex/demo.tex).

## Reutilização e limites

Substitua os metadados e os arquivos de `latex/demo/` por conteúdo do novo estudo e preserve a relação entre cada conclusão e sua evidência; não transfira os achados do Night Heist para outro contexto ([protocolo](../protocol.md)).

A demonstração usa chamadas automáticas autor-data com natbib, mas as referências são registros textuais revisáveis, sem prometer conversão automática integral para NBR 6023:2025; o corpus privado contém edição 2018 corrigida em 2020 e não inclui NBR 6022 ([auditoria](../evidence/standards-audit.md); [UFES](https://biblioteca.ufes.br/normalizacao)).

Resumo e abstract são parágrafos únicos com 100–250 palavras, e as palavras-chave têm separador ponto e vírgula e ponto final; os quadros qualitativos possuem título acima e fonte abaixo, conforme requisitos aplicáveis registrados na auditoria ([auditoria, NBR 6028:2021 e NBR 14724:2024](../evidence/standards-audit.md)).

A assistência de IA é declarada nos documentos; condições da revista-alvo permanecem suspensas nesta etapa, sem submissão ou release científico final ([proveniência](../evidence/manuscript-provenance.md); [decisão editorial](../venue.md)).

O pacote contém apenas os fontes próprios e esta documentação, sem cópias dos PDFs normativos privados ou arquivos de terceiros; o reconhecimento ao abnTeX2 refere-se à referência estrutural consultada, e não à redistribuição de sua classe ([auditoria](../evidence/standards-audit.md); [CTAN e licença do abnTeX2](https://ctan.org/pkg/abntex2)).

## Referências externas validadas

A [conferência de existência, acesso e leitura](../evidence/latex-reference-validation.md) distingue código/PDF lido, metadados lidos e normas cuja íntegra permanece pendente. A bibliografia não inclui o próprio estudo, o protocolo ou a matriz como autoridade externa; o corpus é descrito no método e nos localizadores dos achados. O modelo canônico foi lido no código completo e no PDF de seis páginas, com identificação v1.9.7 de 2018, e não apenas por uma descrição em catálogo.
