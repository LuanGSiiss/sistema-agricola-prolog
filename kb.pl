% Base de conhecimento: domínios, tabelas e fatos estáticos

:- dynamic obs/1.
:- dynamic fired/1.    % registra regras disparadas para explicação

% Domínios/sugestões (ex.: culturas)
culturas([soja, milho, algodao, trigo, feijao]).

% Faixas/valores referenciais (valores em toneladas/ha ou minutos/dias conforme aplic.)
% Exemplos de referência media por cultura (apenas referenciais didáticos)
ref_rendimento(soja, 3.0).    % t/ha
ref_rendimento(milho, 6.5).
ref_rendimento(trigo, 3.2).
ref_rendimento(algodao, 1.8).
ref_rendimento(feijao, 1.5).

% margens financeiras minimas aceitaveis (por hectare, BRL/ha) - valores exemplares
min_margem_segura(500).  % se lucro por ha >= 500 -> financeiramente seguro
min_margem_alerta(0).    % se lucro por ha < 0 -> prejuízo

% notas:
% - Os valores acima são ilustrativos: adapte conforme realidade local/curso.
