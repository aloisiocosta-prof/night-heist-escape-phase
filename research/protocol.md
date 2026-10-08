# Protocolo de estudo — fidelidade GDD → implementação por IA

Estado: planejamento autorizado pelo usuário em 2026-10-08; protocolo elaborado com assistência de IA, sujeito à revisão intelectual de Aloisio e à reavaliação editorial ([decisão](../docs/decisoes/2026-10-08-enquadramento.md)).

## Delimitação

Título de trabalho: **Do GDD discente ao jogo implementado por IA: rastreabilidade e ambiguidades de design no Night Heist**, proposta baseada em antecedentes de análise de GDD e uso de ChatGPT em requisitos ([GDDs, WIE 2023](https://sol.sbc.org.br/index.php/wie/article/view/26349), [requisitos, EDUCOMP 2025](https://doi.org/10.5753/educomp.2025.5370)).

Problema: decisões de implementação precisam ser diferenciadas das decisões explicitamente documentadas pelos designers humanos, sem presumir que toda alteração seja defeito ([EDUCOMP 2025](https://doi.org/10.5753/educomp.2025.5370)).

Pergunta principal: como as decisões do GDD são traduzidas em comportamento executável e quais correspondências, divergências e decisões adicionais aparecem nessa tradução? — formulação proposta, ainda sem resposta empírica ([WIE 2023](https://sol.sbc.org.br/index.php/wie/article/view/26349)).

Objetivo geral: analisar a correspondência entre o GDD e o jogo implementado pelo agente, incluindo a necessidade de resolução de ambiguidades, por estudo de caso documental e verificação técnica ([WIE 2023](https://sol.sbc.org.br/index.php/wie/article/view/26349)).

Objetivos específicos: extrair unidades verificáveis; relacionar unidades a código e testes; classificar correspondência e ambiguidades; registrar decisões e autoria; produzir matriz e checklist reutilizáveis, como entregas propostas ([EDUCOMP 2025](https://doi.org/10.5753/educomp.2025.5370)).

Contribuição pretendida: procedimento auditável de rastreabilidade entre especificação humana e implementação automatizada; originalidade ainda depende de comparação com literatura, sem promessa de novidade ou eficácia educacional ([mapeamento, SBGames 2024](https://doi.org/10.5753/sbgames.2024.241082)).

## Corpus e proveniência

| Item | Situação | Tratamento |
|---|---|---|
| GDD discente original | Informado pelo usuário; não localizado nas buscas desta etapa | Solicitar arquivo exato, versão, datas e condições de uso |
| Código do jogo | Baseline 72699f0c2752d029d8e8c3b48420c18a70dbe2a1 | Fixar baseline; mudanças posteriores são outro corpus |
| DESIGN/BACKLOG/VALIDATION | Disponíveis | Fontes secundárias internas; não substituem GDD |
| Conversas com agente | Não incorporadas ao corpus | Identificar registros originais; nunca reconstruir como transcrição |
| Autoria do design | Alunos, segundo declaração do usuário | Conferir crédito, titularidade e permissões |
| Implementação | Agente ChatGPT, segundo declaração do usuário | Declarar assistência; não atribuir programação aos alunos sem evidência |

O estado da documentação é rastreável à [auditoria](evidence/repository-audit.md); possuir o GDD não estabelece automaticamente permissão de divulgação ou dispensa ética ([CNS 510/2016](https://bvsms.saude.gov.br/bvs/saudelegis/cns/2016/res0510_07_04_2016.html)).

## Procedimento proposto

1. Registrar identificação, versão e SHA-256 do GDD, condições de acesso e permissão, sem publicar nomes, notas ou materiais escolares privados ([CNS 510/2016](https://bvsms.saude.gov.br/bvs/saudelegis/cns/2016/res0510_07_04_2016.html)).
2. Extrair unidades atômicas do documento original, preservando página/seção e trecho curto, separando comportamento obrigatório, preferência, exemplo e ausência de especificação ([WIE 2023](https://sol.sbc.org.br/index.php/wie/article/view/26349)).
3. Definir critério observável para cada unidade e verificar código e execução separadamente; teste somente planejado não é evidência de execução ([auditoria](evidence/repository-audit.md)).
4. Classificar correspondência segundo o codebook antes de computar frequências; conservar casos não verificáveis no denominador e reportá-los separadamente ([codebook](codebook.md)).
5. Registrar ambiguidade, resolução e evidência de quem decidiu; usar autoria `unknown` quando não houver registro, sem dedução a partir de commits automatizados ([codebook](codebook.md)).
6. Revisar classificações humanas e registrar divergências; um segundo pesquisador pode revisar artefatos, sem avaliar alunos, e concordância só será relatada se medida ([codebook](codebook.md)).
7. Relatar contagens por categoria, proporções com denominadores explícitos e exemplos negativos; não transformar unidades do mesmo documento em participantes independentes nem fazer inferência causal ([codebook](codebook.md)).

## Ética, limites e publicação

A unidade de análise proposta é a decisão documentada e sua implementação, não a competência dos estudantes; nenhum resultado de aprendizagem será inferido do jogo pronto ([Prather et al., 2024](https://doi.org/10.1145/3632620.3671116)).

A origem discente do GDD exige avaliação de direitos e enquadramento; não há dispensa de CEP declarada, e estudar vivências, desempenho ou produções como dados dos alunos muda o escopo ([CNS 510/2016](https://bvsms.saude.gov.br/bvs/saudelegis/cns/2016/res0510_07_04_2016.html)).

Este protocolo contém concepção e método assistidos por IA; Educitec passa a **destino em reavaliação**, pois sua política restringe geração de conteúdo científico por IA, e revisão humana não deve ser apresentada como apagamento dessa proveniência ([política de IA](https://sistemascmc.ifam.edu.br/educitec/index.php/educitec/politicadeusodeia)).

Resultados: **pendentes**; limitações previstas: caso único, ausência do GDD no corpus atual, possível incompletude de logs, viés do pesquisador envolvido, e impossibilidade de inferir aprendizagem ou superioridade da IA ([Prather et al., 2024](https://doi.org/10.1145/3632620.3671116)).
