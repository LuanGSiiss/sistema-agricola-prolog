
% Regras de negocio que definirão o diagnostico da safra
:- consult(kb).
:- dynamic fired/1.

% meta/1 devolve estrutura com diagnostico principal
% Ex.: meta(diagnostico(produtividade(alta), financeiro(viavel), recomendacao(...)))
meta(diagnostico(produtividade(Prod), financeiro(Fin), risco(Risco), recomendacao(Rec))) :-
    % limpa disparos antigos
    retractall(fired(_)),

    % derivacoes básicas
    produtividade(Prod),
    financeiro(Fin),
    risco_geral(Risco),
    recomendacao(Rec).

/* ===== Regras para produtividade =====
   Baseadas em rendimento esperado vs historico e fatores adversos
*/

% regra 1: produtividade alta se rendimento esperado >= 120% do historico e fertilizante ok e sem pragas
produtividade(alta) :-
    obs(rendimento_esperado(E)),
    obs(rendimento_historico(H)),
    E >= H * 1.20,
    obs(fertilizante_suficiente(sim)),
    obs(pestes(nao)),
    assertz(fired(reg_produto_alta)),
    !.

% regra 2: produtividade media se rendimento esperado entre 90% e 120% do historico e fertilizante ok
produtividade(media) :-
    obs(rendimento_esperado(E)),
    obs(rendimento_historico(H)),
    E >= H * 0.90,
    E < H * 1.20,
    obs(fertilizante_suficiente(sim)),
    assertz(fired(reg_produto_media)),
    !.

% regra 3: produtividade baixa se rendimento esperado < 90% do historico ou fatores adversos
produtividade(baixa) :-
    ( obs(rendimento_esperado(E)), obs(rendimento_historico(H)), E < H * 0.90
    ; obs(fertilizante_suficiente(nao))
    ; obs(pestes(sim))
    ; obs(seca(sim))
    ),
    assertz(fired(reg_produto_baixa)),
    !.

% regra 4: produtividade incerta quando faltam dados essenciais
produtividade(incerta) :-
    ( \+ obs(rendimento_esperado(_)) ; \+ obs(rendimento_historico(_)) ),
    assertz(fired(reg_produto_incerta)),
    !.

/* ===== Regras para financeiro =====
   Calcula receita, custo, lucro por ha e decide viabilidade financeira
*/

% receita_total_por_ha = rendimento_esperado * preco_tonelada
receita_por_ha(Receita) :-
    obs(rendimento_esperado(E)),
    obs(preco_tonelada(P)),
    Receita is E * P.

% lucro_por_ha = receita - custo_por_ha
lucro_por_ha(Lucro) :-
    receita_por_ha(R),
    obs(custo_por_ha(C)),
    Lucro is R - C.

% financeiro(viavel) se margem >= min_margem_segura
financeiro(viavel) :-
    lucro_por_ha(L),
    min_margem_segura(Min),
    L >= Min,
    assertz(fired(reg_fin_viavel)),
    !.

% financeiro(precaucao) se lucro positivo mas abaixo da margem segura
financeiro(precaucao) :-
    lucro_por_ha(L),
    min_margem_segura(Min),
    L > min_margem_alerta,
    L < Min,
    assertz(fired(reg_fin_precaucao)),
    !.

% financeiro(nao_viavel) se prejuizo (lucro < 0)
financeiro(nao_viavel) :-
    lucro_por_ha(L),
    L =< 0,
    assertz(fired(reg_fin_naoviavel)),
    !.

% financeiro(incerto) se faltam dados
financeiro(incerto) :-
    ( \+ receita_por_ha(_) ; \+ lucro_por_ha(_) ),
    assertz(fired(reg_fin_incerto)),
    !.

/* ===== Regras de risco geral =====
   Combina produtividade e fatores de risco (pestes, seca, irrigacao)
*/

risco_geral(alto) :-
    produtividade(baixa),
    (obs(pestes(sim)); obs(seca(sim))),
    assertz(fired(reg_risco_alto)),
    !.

risco_geral(medio) :-
    produtividade(media),
    (obs(pestes(sim)); obs(seca(sim))),
    assertz(fired(reg_risco_medio)),
    !.

risco_geral(baixo) :-
    produtividade(alta),
    obs(pestes(nao)),
    obs(seca(nao)),
    assertz(fired(reg_risco_baixo)),
    !.

risco_geral(incerto) :-
    assertz(fired(reg_risco_incerto)),
    !.

/* ===== Regras de recomendacao =====
   Indicam acao sugerida com base em combinacoes
*/

recomendacao(apenas_monitorar) :-
    produtividade(alta),
    financeiro(viavel),
    assertz(fired(reg_rec_monitorar)),
    !.

recomendacao(agir_controle_pragas) :-
    obs(pestes(sim)),
    assertz(fired(reg_rec_controle_pestes)),
    !.

recomendacao(considerar_irrigacao) :-
    obs(seca(sim)),
    obs(irrigacao(nao)),
    assertz(fired(reg_rec_irrigacao)),
    !.

recomendacao(procurar_subsidio) :-
    financeiro(nao_viavel),
    obs(subsidio_disponivel(sim)),
    assertz(fired(reg_rec_subsidio)),
    !.

recomendacao(reavaliar_tecnicas) :-
    produtividade(baixa),
    obs(fertilizante_suficiente(nao)),
    assertz(fired(reg_rec_reavaliar_fert)),
    !.

recomendacao(avaliacao_tecnica) :-
    assertz(fired(reg_rec_avaliacao_generica)),
    !.
