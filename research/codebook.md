# Codebook operacional proposto

As categorias são uma adaptação para este estudo, não escala validada; a análise documental de GDD tem antecedentes em [WIE 2023](https://sol.sbc.org.br/index.php/wie/article/view/26349).

| Classificação | Regra operacional |
|---|---|
| preserved | Todos os critérios explícitos da unidade são atendidos na evidência examinada |
| partial | Parte dos critérios é atendida, com partes faltantes especificadas |
| altered | Existe implementação correspondente, mas contradiz pelo menos um critério explícito |
| omitted | Unidade explícita aplicável não tem implementação após busca e verificação registradas |
| added | Comportamento implementado sem unidade correspondente no GDD completo |
| unverifiable | Fonte, escopo ou execução insuficientes para decidir |

As regras acima devem ser aplicadas com justificativa e localizadores na [matriz](instruments/fidelity.csv); ausência de trecho em DESIGN.md não demonstra ausência no GDD original.

Ambiguidade: `none`, `lexical`, `conflicting`, `missing_parameter`, `scope_unclear` ou `unknown`; múltiplas ocorrências devem ser separadas em registros, preservando exemplos contextuais ([matriz](instruments/fidelity.csv)).

Responsável por decisão: `student`, `teacher`, `agent`, `joint` ou `unknown`; usar somente registro original verificável, sem atribuição automática baseada no relato geral de programação por IA ([protocolo](protocol.md)).

Estado de evidência: `planned`, `static_inspection`, `executed` ou `not_available`; aprovação humana: `pending`, `reviewed` ou `disputed`, independente do resultado técnico ([protocolo](protocol.md)).

Para unidades explícitas: reportar N e contagens em cada categoria; taxa de preservação = preserved/N, incluindo unverifiable em N; acrescentar taxa de verificabilidade e análise separada das adições, sem apresentar um índice global de qualidade ou aprendizagem ([protocolo](protocol.md)).
