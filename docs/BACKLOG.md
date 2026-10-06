# Backlog rastreável ao GDD 0.2

Fonte: GDD fornecido, Night Heist: Escape Phase V2, versão 0.2; páginas 1–7.

| ID | Requisito | Aceitação | Estado |
|---|---|---|---|
| REQ-01 | Corrida, salto, agachamento e escadas em quatro pavimentos | Teclado e controles touch; travessia de ida e volta | Implementado; física coberta por testes; touch requer aparelho |
| REQ-02 | Temporizador de missão | Iniciar ao entrar; falhar ao zerar; parar no resultado | Implementado e testado, incluindo pausa |
| REQ-03 | Skill check de portas | Acerto abre; erro dispara alarme ou bloqueio temporário | Implementado e testado |
| REQ-04 | Câmeras e lasers diagonais | Exposição contínua >0,5 s aciona alerta; laser dispara alarme | Implementado e testado; inclui hack temporário |
| REQ-05 | Saque e retorno ao spawn | Vitória apenas com cofre coletado e retorno antes do timeout | Implementado e testado |
| REQ-06 | Polimento audiovisual | Paleta do GDD; feedback visual/sonoro e iluminação | Sprites, sons originais e cones de luz implementados |
| CI-01 | Exportações Web e Android | Arquivos gerados, scripts e gameplay testados, assinatura APK verificada | Automatizado em Actions |
| CD-01 | Pages e Releases | Pages em main; APK preview e Web ZIP em tags v* | Automatizado; versão 0.2.0 inclui o gameplay |

Sem grade descendente, conforme versão 0.2. Ver decisões de balanceamento em DESIGN.md e limites da validação em VALIDATION.md.
