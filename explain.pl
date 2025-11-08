% Imprime trilha das regras acionadas e explica o porquê do resultado

:- consult(kb).
:- dynamic fired/1.

explicar(diagnostico(produtividade(Prod), financeiro(Fin), risco(Risco), recomendacao(Rec))) :-
  % recolhe dados basicos se existirem
  ( obs(cultura(C)) -> true ; C = desconhecida ),
  ( obs(area(A)) -> true ; A = desconhecida ),
  ( obs(rendimento_esperado(E)) -> true ; E = desconhecido ),
  ( obs(rendimento_historico(H)) -> true ; H = desconhecido ),
  ( obs(pestes(P)) -> true ; P = desconhecida ),
  ( obs(seca(S)) -> true ; S = desconhecida ),
  ( obs(fertilizante_suficiente(Fert)) -> true ; Fert = desconhecida ),
  ( obs(irrigacao(Irr)) -> true ; Irr = desconhecida ),
  ( obs(preco_tonelada(Preco)) -> true ; Preco = desconhecida ),
  ( obs(custo_por_ha(Custo)) -> true ; Custo = desconhecida ),

  format("~n[Explicacao do Diagnostico]~n"),
  format("- Cultura: ~w | Area (ha): ~w~n", [C, A]),
  format("- Rendimento esperado: ~w t/ha | Historico: ~w t/ha~n", [E, H]),
  format("- Pragas: ~w | Seca: ~w | Fertilizante adequado: ~w | Irrigacao: ~w~n",
         [P, S, Fert, Irr]),
  format("- Preco/ton: ~w | Custo/ha: ~w~n~n", [Preco, Custo]),

  format("Regras que foram acionadas:~n"),
  ( fired(R) -> (forall(fired(Rule), (format("  - ~w~n", [Rule])))) ; format("  Nenhuma regra registrada.~n") ),

  % detalhe de alguns calculos quando possiveis
  ( receita_por_ha(Rpor) -> format("Receita estimada por ha: ~2f BRL~n", [Rpor]) ; format("Receita estimada por ha: dados insuficientes~n") ),
  ( lucro_por_ha(Lpor) -> format("Lucro estimado por ha: ~2f BRL~n", [Lpor]) ; format("Lucro estimado por ha: dados insuficientes~n") ),

  format("~nResumo:~n"),
  format("- Produtividade avaliada como: ~w~n", [Prod]),
  format("- Situacao financeira avaliada como: ~w~n", [Fin]),
  format("- Nivel de risco da safra: ~w~n", [Risco]),
  format("- Recomendacao sugerida: ~w~n", [Rec]).
