# Night Heist — projeto acadêmico científico

Estado: `pesquisa-em-planejamento`; orientador: Aloisio de Araújo Costa Magalhães; destino editorial: Educitec em reavaliação; versão científica: sem release aprovado ([decisão](../docs/decisoes/2026-10-08-enquadramento.md)).

O artefato auditado é um jogo Godot 4.4.1/GDScript, com exportações Web e Android, regras de missão e testes automatizados; a transformação acadêmica documenta esse artefato e organiza o trabalho científico humano sem substituir a implementação existente ([auditoria](evidence/repository-audit.md)).

O enquadramento temático administrativo é “processos e recursos para o ensino técnico de Análise e Desenvolvimento de Sistemas”; adequação temática não comprova contribuição científica, eficácia didática ou aceitação editorial ([Educitec, políticas de seção](https://sistemascmc.ifam.edu.br/educitec/index.php/educitec/FocoeEscopo)).

## Documentos

- [Auditoria de issues, PR e software](evidence/repository-audit.md).
- [Validação e comparação editorial](venue.md).
- [Plano de execução e lacunas científicas](plan.md).
- [Registro de evidências](evidence/claims.csv).
- [Ficha vazia de execução técnica](instruments/technical-run.csv).
- [Fonte LaTeX do dossiê](../latex/main.tex).
- [Política de licenciamento](../LICENSE-POLICY.md).

## Execução documental

```bash
python3 tools/check_academic.py
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build/academic latex/main.tex
```

A compilação gera um dossiê de planejamento, sem resultados educacionais; o arquivo editorial definitivo dependerá do template oficial e da elaboração científica humana ([Educitec, diretrizes](https://sistemascmc.ifam.edu.br/educitec/index.php/educitec/Diretrizes)).

## Estudo selecionado

[Protocolo GDD → jogo](protocol.md), [codebook](codebook.md) e [matriz de fidelidade](instruments/fidelity.csv) implementam o recorte autorizado, com classificações estáticas preliminares pendentes de revisão humana; [leads.csv](evidence/leads.csv) contém pistas internas que exigem conferência no GDD original.

## Identificação

Dados fornecidos pelo usuário em 2026-10-08; registro estruturado em [metadata.json](metadata.json).

- Orientador: Aloisio de Araújo Costa Magalhães.
- Autores: ENZO EMANUEL BATISTA DE SOUSA; FRANCISCO ANTONIO CARDOSO RIBEIRO; GABRIEL SILVA SOARES; JUAN RANGEL FERREIRA DA SILVA; RAFAEL ASSUNÇÃO SANTOS.
- Curso: Análise e Desenvolvimento de Sistemas.
- Instituição: Unidade Escolar Lucas Meireles Alves.
- Localidade: Chapadinha Sul.
- Cidade: Teresina.
- Estado: Piauí.

[GDD localizado e proveniência](evidence/gdd-source.md): versão interna 0.2 / V2, com seis unidades analisadas por inspeção estática.
