Você é um investigador técnico. NÃO implemente nada e NÃO edite código de produção
nesta rodada. Sua entrega é um parecer + um plano acionável. Quem vai implementar
depois é o Opus, então o plano precisa estar pronto para handoff.

## Contexto do projeto

Template Flutter (Stacked + Firebase, FVM). Experimentos de animação vivem em:

- `lib/ui/views/cue_test/` — 12 demos usando o pacote `cue: ^0.3.1`
  (Cue.onMount / onToggle / onScrollVisible / onHover, Actor + Act.*).
- `lib/ui/views/try_staggered_animation_two/` — fluxo multi-step (getStarted →
  number → sms → profile) com `AnimationController` manual, `FadeTransition`/
  `SlideTransition` e transições sobrepostas em `Stack`.

O `pubspec.yaml` JÁ inclui `golden_toolkit: ^0.15.0` e `flutter_test`. NÃO há
diretório `integration_test/`.

## Parte 1 — Análise superficial (rápida, sem mergulhar)

Faça um mapeamento superficial das duas telas de animação:
- Que técnicas/APIs cada uma usa (cue vs. AnimationController manual).
- Como a animação é disparada, controlada e como o "estado bom" é percebido hoje
  (hoje só o olho humano vê).
- Diferenças relevantes entre as duas abordagens para o objetivo abaixo.

Mantenha curto — é reconhecimento de terreno, não auditoria.

## Parte 2 — A pergunta central (o foco de verdade)

Quero viabilizar este fluxo de trabalho:

1. Eu peço à IA: "faça uma tela com uma animação assim e assado".
2. A própria IA constrói a animação.
3. A própria IA CONSEGUE VER o resultado renderizado (não só o código).
4. Ela critica o que viu e aprimora — um loop de refinamento autônomo.
5. Quando ela julgar que ficou bom, ela PARA.
6. Só então eu abro e vejo o resultado final.

Responda, de forma objetiva:

**a) É possível?** Veredito claro (sim / sim-com-ressalvas / não) e por quê.

**b) Como a IA "vê" uma animação (que é temporal)?** O gargalo é que um único
   screenshot não captura movimento. Avalie e compare os caminhos:
   - `golden_toolkit` / `flutter_test` renderizando o widget e bombeando
     (`tester.pump(Duration)`) para amostrar N frames em timestamps → "filmstrip"
     de PNGs que um modelo com visão consegue ler.
   - Golden tests tradicionais (frame único por estado).
   - Gravar o app rodando (screenshot/vídeo em emulador ou desktop) — mais caro.
   - Qualquer alternativa melhor que você enxergar.
   Diga qual é o caminho recomendado para ESTE projeto e por quê (leve em conta
   que golden_toolkit já está instalado e não exige emulador).

**c) Como fechar o loop de refinamento?** Descreva o mecanismo concreto:
   - Como gerar os frames de forma reproduzível e barata a cada iteração.
   - Como o modelo lê os frames e decide "bom o suficiente" (critérios objetivos:
     timing, easing, sobreposição, sem saltos/jank perceptível, etc.).
   - Critério de PARADA (evitar loop infinito): nº máximo de iterações, rubrica
     de qualidade, ou checagem de convergência.

**d) Como construir isso na prática?** Um passo a passo de implementação para o
   Opus executar depois: que arquivos/harness criar (ex.: um helper de "filmstrip"
   em `test/`, um comando para rodar e despejar os PNGs numa pasta que o agente
   lê), como isolar o widget de animação para renderizar sem Firebase/locator,
   e como encaixar isso no ciclo do agente.

**e) Limites e riscos.** Onde isso quebra: animações dependentes de gesto/scroll/
   hover, `cue` vs. controller manual, custo por iteração, falsos "está bom".

## Formato da saída

- Parecer curto na Parte 1.
- Parte 2 estruturada nos itens a–e.
- Termine com um "Plano de implementação para o Opus" enumerado e acionável.
- Sem código de produção agora; snippets ilustrativos do harness são bem-vindos.
