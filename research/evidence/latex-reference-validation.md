# Validação de existência, acesso e leitura — LaTeX e ABNT

Conferência: 8 out. 2026. Este registro verifica fontes externas e não é referência bibliográfica usada para sustentar o próprio estudo. A existência, a possibilidade de acesso e a leitura do conteúdo são estados diferentes; não se infere leitura integral a partir de uma página de catálogo.

| ID | Fonte externa e identificação | Existência e acesso verificados | Conteúdo efetivamente lido | Limite da validação |
|---|---|---|---|---|
| LAT01 | Equipe abnTeX2; Lauro César Araujo. Modelo canônico de artigo científico com abnTeX2. v1.9.7, 2018 | [Código GitHub](https://github.com/abntex/abntex2/blob/master/doc/latex/abntex2/examples/abntex2-modelo-artigo.tex) e [PDF CTAN](https://ctan.math.washington.edu/tex-archive/macros/latex/contrib/abntex2/doc/examples/abntex2-modelo-artigo.pdf), públicos | Arquivo `.tex` completo, 498 linhas; PDF de seis páginas, extração textual completa. Blob GitHub `9c38dc56d0d7b4fd62267ba2394afa484049ce52` | Exemplo técnico de 2018; declara NBR 6022:2018, usa pontos entre palavras-chave e menciona NBR 10520:2002, portanto não valida atualização integral a 2021/2023/2025 |
| LAT02 | CTAN. AbnTeX2 — registro de pacote | [Página do pacote](https://ctan.org/pkg/abntex2), pública | Metadados: versão 1.9.7, data 24 nov. 2018, licença LPPL 1.3, mantenedor, links para documentação e distribuição | Registro técnico; não artigo científico revisado por pares e não certificação de todas as normas atuais |
| LAT03 | CTAN. BibLaTeX-abnt — registro de pacote | [Página do pacote](https://ctan.org/pkg/biblatex-abnt), pública | Metadados: versão 4.0, licença LPPL 1.3c, copyright 2016–2017 e links de documentação | Nesta conferência, não foi lido o manual completo do pacote; nenhuma compatibilidade com NBR 6023:2025 é inferida da existência do pacote. Ele não é utilizado como motor bibliográfico na demonstração |
| NOR01 | UFES. Sistema Integrado de Bibliotecas. Normalização. Atualizada em 10 jul. 2026 | [Página institucional](https://biblioteca.ufes.br/normalizacao), pública | Lista de normas e orientações de acesso: 6022:2018, 6028:2021, 10520:2023, 14724:2024, 6023:2025; alerta sobre manuais desatualizados | Fonte institucional para identificar edições; não equivale à leitura integral de cada norma. A página indica Target GEDWeb para acesso autorizado à íntegra |
| NOR02 | ABNT NBR 6028:2021 | PDF existente e recuperado do acervo privado fornecido pelo usuário | Texto extraído e lido: parágrafo único, extensão 100–250 para artigos e palavras-chave com ponto e vírgula | Acesso comprovado no acervo autorizado; não se afirma acesso público universal |
| NOR03 | ABNT NBR 10520:2023 | PDF existente e recuperado do acervo privado fornecido pelo usuário | Texto extraído e lido: sistema de chamada e grafia normal nas citações autor-data | Não é documentação de um pacote LaTeX; o resultado compilado precisa ser confrontado com os requisitos |
| NOR04 | ABNT NBR 14724:2024 | PDF existente e recuperado do acervo privado fornecido pelo usuário | Texto extraído e lido: parâmetros de apresentação, espaçamento e elementos gráficos | Norma de trabalhos acadêmicos, aplicada por adaptação; não substitui NBR 6022 para artigo |
| NOR05 | ABNT NBR 6023:2018, versão corrigida 2 de 2020 | PDF existente e recuperado do acervo privado fornecido pelo usuário | Requisitos de apresentação de referências lidos | Edição histórica; a UFES identifica edição 2025. Não é apresentada como atual |
| NOR06 | ABNT NBR 6022:2018 e ABNT NBR 6023:2025 | Existência/edições confirmadas na fonte institucional NOR01 | Texto normativo integral não lido nesta etapa | Permanecem pendentes de confronto integral; não se declara conformidade total |

As localizações internas e hashes dos PDFs efetivamente recuperados estão em `standards-audit.md`; esse registro de proveniência não integra a bibliografia do artigo como fundamentação do próprio estudo.

## Correções da bibliografia

- Retirados os itens próprios `Night Heist` e `Sousa et al.` e as chamadas ao corpus, protocolo ou matriz como se fossem literatura externa.
- GDD, código e instrumentos próprios passam a ser identificados na descrição do corpus, nos localizadores dos resultados e nas fontes dos quadros.
- Normas, documentação de software, página institucional e literatura científica externa são identificadas conforme sua natureza; documentação técnica não é apresentada como artigo científico.
- O ano da página UFES foi corrigido para a atualização explicitamente informada, 10 jul. 2026, em vez de usar o ano da consulta como substituto de uma data desconhecida.
- Nenhum DOI foi inventado para o template: sua rastreabilidade utiliza versão, autoria, URL do PDF e blob do código.

## Falhas de acesso e rotas efetivas

O navegador de pesquisa não conseguiu recuperar a URL raw do GitHub; o código completo foi lido pela conexão GitHub. O link genérico `mirrors.ctan.org` redirecionou para espelho indisponível na ferramenta; o PDF do espelho CTAN da Universidade de Washington foi aberto e lido. Essas falhas não foram rotuladas como inexistência da fonte. Páginas de artigos da SBC apresentaram timeout nesta conferência; essa nova tentativa não foi registrada como nova leitura integral desses artigos.
