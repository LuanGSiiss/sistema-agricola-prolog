% Arquivo principal
:- initialization(start).

:- ["kb.pl","rules.pl","ui.pl","explain.pl"].

start :-
    banner, menu.

banner :-
  format("~n=== Sistema Especialista: Diagnostico da Safra ===~n"),
  format("Desenvolvido por: Luan Gerber Siiss e Guilherme Afonso Casa~n~n").

menu :-
  format("1) Executar diagnostico~n2) Sair~n> "),
  read(Opt),
  ( Opt = 1 -> run_case, cleanup_all, menu
  ; Opt = 2 -> format("Saindo...~n")
  ; format("Opcao invalida.~n"), menu ).

run_case :-
  coletar_observacoes,
  ( meta(Result) ->
      explicar(Result),
      format("~nRESULTADO FINAL: ~w~n~n", [Result])
  ; format("~nNao foi possivel concluir o diagnostico. Verifique as respostas.~n~n")
  ),
  true.
