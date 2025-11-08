# Sistema Especialista em Diagnóstico da Safra

Desenvolvedores:
@Luan Gerber Siiss
@Guilherme Afonso Casa

---

## Objetivo

Nosso sistema especialista em Prolog tem como objetivo diagnosticar a situação de uma safra agrícola, avaliando produtividade, viabilidade financeira, risco e recomendação com base em informações fornecidas pelo usuário.

O sistema utiliza fatos e regras para inferir conclusões sobre o desempenho esperado da safra e possíveis ações corretivas.

---

## Estrutura do Projeto

diagnostico_safra/
- main.pl % Arquivo principal (menu e orquestração)
- kb.pl % Base de conhecimento (fatos, tabelas, domínios)
- rules.pl % Regras lógicas e inferências
- ui.pl % Interface textual (perguntas e coleta de dados)
- explain.pl % Geração de explicação e trilha de regras
- README.md


---

## Instalação e Execução

### 1 - Requisitos
- **SWI-Prolog** instalado (https://www.swi-prolog.org/download/)

### 2 - Execução
Abra o terminal na pasta do projeto e digite:
    swipl -s main.pl
Ou acesse a consulta do SWI-Prolog abrindo o arquivo main.pl

Exemplo de Execução

Cultura: soja
Area cultivada: 10
Rendimento esperado: 3.0
Rendimento historico: 3.2
Preco por tonelada: 2200
Custo por ha: 1700
Pragas: n
Seca: n
Fertilizante suficiente: s
Irrigacao: n
Subsidio: n

---

## Funcionamento Lógico

O sistema armazena os dados com assertz/1 e aplica regras de inferência para determinar:
- Produtividade (alta, média, baixa, incerta)
- Situação financeira (viável, precaução, não viável)
- Nível de risco (baixo, médio, alto)
- Recomendação (monitorar, controle de pragas, buscar subsídio, etc.)
Todas as regras que contribuíram para o resultado são registradas em fired/1 e listadas na explicação final.
