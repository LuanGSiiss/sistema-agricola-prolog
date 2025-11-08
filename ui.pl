% Perguntas e assert/1 das observações

:- consult(kb).
:- dynamic obs/1.

% Pergunta genérica de sim/nao
pergunta_binaria(Campo, Texto) :-
    format("~w (s/n): ", [Texto]),
    read(Ans0),
    downcase_atom(Ans0, Ans),
    ( Ans == s ->
        Term =.. [Campo, sim], assertz(obs(Term))
    ; Ans == n ->
        Term =.. [Campo, nao], assertz(obs(Term))
    ; format("Entrada invalida. Digite s ou n.~n"),
      pergunta_binaria(Campo, Texto)
    ).

% Coleta observacoes especificas do dominio agricola
coletar_observacoes :-
    format("Cultura (ex.: soja, milho, trigo, algodao, feijao): "),
    read(Cult0),
    downcase_atom(Cult0, Cult),
    assertz(obs(cultura(Cult))),

    format("Area cultivada (ha) - numero (ex.: 10): "),
    read(Area),
    assertz(obs(area(Area))),

    format("Rendimento esperado (t/ha) - numero (ex.: 3.2): "),
    read(RendEsp),
    assertz(obs(rendimento_esperado(RendEsp))),

    format("Rendimento historico médio (t/ha) - numero (ex.: 3.0): "),
    read(RendHist),
    assertz(obs(rendimento_historico(RendHist))),

    format("Preco de mercado por tonelada (BRL) - numero (ex.: 2000): "),
    read(Preco),
    assertz(obs(preco_tonelada(Preco))),

    format("Custo de producao total por ha (BRL/ha) - numero (ex.: 1500): "),
    read(Custo),
    assertz(obs(custo_por_ha(Custo))),

    % perguntas binarias
    pergunta_binaria(pestes, "Incidencia de pragas/doencas elevada?"),
    pergunta_binaria(seca, "Periodo seco/deficit de chuva atual?"),
    pergunta_binaria(fertilizante_suficiente, "Uso de fertilizante adequado?"),
    pergunta_binaria(irrigacao, "Irrigacao disponivel na area?"),
    pergunta_binaria(subsidio_disponivel, "Subsidio / apoio governamental disponivel?").

% cleanup local (apagar obs e regras disparadas)
cleanup_all :-
    retractall(obs(_)),
    retractall(fired(_)).
