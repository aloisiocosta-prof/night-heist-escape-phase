# GDD localizado — registro de fonte

Arquivo: GDD - Night Heist Escape Phase (Versão 0).pdf; identificador Drive: 1PSatYPYRYxb4pFmQwM0Lt-A4GYpDOkjc; tamanho informado: 142006 bytes; leitura textual em 2026-10-08; última modificação informada: 2026-10-08T17:17:14.586Z ([fonte](https://drive.google.com/file/d/1PSatYPYRYxb4pFmQwM0Lt-A4GYpDOkjc/view)).

Identificação interna: Night Heist: Escape Phase V2, versão 0.2, MVP sem grade descendente; a divergência com o nome do arquivo deve ser conservada, sem renomear silenciosamente a fonte ([GDD](https://drive.google.com/file/d/1PSatYPYRYxb4pFmQwM0Lt-A4GYpDOkjc/view)).

A leitura foi textual, com localizadores por seção; bytes originais, hash SHA-256, paginação e mockup não foram materializados nesta etapa; a cópia integral não foi publicada no repositório ([GDD](https://drive.google.com/file/d/1PSatYPYRYxb4pFmQwM0Lt-A4GYpDOkjc/view)).

Autoria discente declarada pelo usuário; o corpo textual retornado não contém identificação autoral; não se deduz autoria individual de cada decisão nem autorização de publicação integral ([GDD](https://drive.google.com/file/d/1PSatYPYRYxb4pFmQwM0Lt-A4GYpDOkjc/view)).

## Análise inicial assistida por IA

A matriz contém seis unidades selecionadas, sem alegação de cobertura exaustiva e sem taxas globais; classificações derivam de leitura estática, não de execução ou revisão humana concluída ([matriz](../instruments/fidelity.csv)).

O GDD especifica quatro pavimentos, câmera com limiar superior a 0,5 s, saque e retorno ao ponto exato inicial e falha por esgotamento do tempo; o código usa quatro níveis, limiar de 0,5 s, vitória condicionada ao saque e tolerância de distância inferior a 30 px ([GDD](https://drive.google.com/file/d/1PSatYPYRYxb4pFmQwM0Lt-A4GYpDOkjc/view), [baseline](https://github.com/aloisiocosta-prof/night-heist-escape-phase/tree/72699f0c2752d029d8e8c3b48420c18a70dbe2a1)).

Duração de 180 s, penalidade de 8 s, cooldown de 3 s e desativação de segurança por 12 s são parâmetros encontrados no código sem valores explícitos correspondentes na leitura do GDD, classificados como complementação operacional pendente de confirmação, sem atribuir o decisor ([GDD](https://drive.google.com/file/d/1PSatYPYRYxb4pFmQwM0Lt-A4GYpDOkjc/view), [código](https://github.com/aloisiocosta-prof/night-heist-escape-phase/blob/72699f0c2752d029d8e8c3b48420c18a70dbe2a1/scripts/mission.gd)).

A classificação de retorno como alterado registra a diferença literal entre ponto exato e raio de 30 px; a justificativa de usabilidade pode ser examinada posteriormente, sem converter divergência em defeito automaticamente ([GDD](https://drive.google.com/file/d/1PSatYPYRYxb4pFmQwM0Lt-A4GYpDOkjc/view), [código](https://github.com/aloisiocosta-prof/night-heist-escape-phase/blob/72699f0c2752d029d8e8c3b48420c18a70dbe2a1/scripts/main.gd)).
