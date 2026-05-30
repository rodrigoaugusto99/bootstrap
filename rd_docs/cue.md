# Cue — Guia Completo de Animações

`cue` (`^0.3.1`, publisher verificado **codeness.ly**, autor Milad Akarie) é uma
biblioteca de animações **physics-first** para Flutter, com uma API
**declarativa e composável baseada em timeline**. A ideia central é descrever
_o que_ anima, _quando_ anima e _como se move_ — sem fios imperativos
(`AnimationController`, `Tween`, `addListener`) espalhados pela árvore de widgets.

> Repositório: https://github.com/Milad-Akarie/cue · pub.dev: https://pub.dev/packages/cue

---

## Índice

1. [Conceitos: os 5 blocos](#conceitos-os-5-blocos)
2. [Setup neste projeto](#setup-neste-projeto)
3. [Sintaxe: dot-shorthand vs. explícita](#sintaxe-dot-shorthand-vs-explícita)
4. [Cue — os gatilhos](#cue--os-gatilhos)
5. [Actor — o renderizador](#actor--o-renderizador)
6. [Act — todos os efeitos](#act--todos-os-efeitos)
7. [CueMotion — timing e física](#cuemotion--timing-e-física)
8. [Keyframes — animação multi-etapa](#keyframes--animação-multi-etapa)
9. [Reverse, delay e stagger](#reverse-delay-e-stagger)
10. [Controllers e uso imperativo](#controllers-e-uso-imperativo)
11. [Helpers de alto nível](#helpers-de-alto-nível)
12. [Receitas práticas (o que dá pra fazer)](#receitas-práticas-o-que-dá-pra-fazer)
13. [DevTools](#devtools)
14. [Regras e armadilhas](#regras-e-armadilhas)

---

## Conceitos: os 5 blocos

| Bloco           | Papel        | Pergunta que responde                          |
| --------------- | ------------ | ---------------------------------------------- |
| **`Cue`**       | Gatilho      | _Quando_ a animação roda?                      |
| **`Actor`**     | Renderizador | _Qual_ widget anima?                           |
| **`Act`**       | Efeito       | _Qual_ propriedade muda e entre quais valores? |
| **`CueMotion`** | Timing       | _Como_ se move (mola ou curva)?                |
| **`Keyframes`** | Multi-etapa  | Sequência de vários alvos                      |

Fluxo: um `Cue` publica um `CueController` para a subárvore via `CueScope`.
Qualquer `Actor` abaixo dele consome esse controller para aplicar seus `Act`s.

```dart
Cue.onMount(                       // QUANDO: ao montar
  motion: CueMotion.smooth(),      // COMO: mola suave
  child: Actor(                    // QUAL widget
    acts: [                        // QUAIS efeitos
      Act.fadeIn(),
      Act.slideY(from: 0.2),
      Act.scale(from: 0.96),
    ],
    child: const Text('Hello Cue'),
  ),
)
```

Atalho para um único filho — passe `acts` direto no `Cue` e omita o `Actor`:

```dart
Cue.onMount(
  motion: CueMotion.smooth(),
  acts: [Act.fadeIn(), Act.slideY(from: 0.2)],
  child: const Text('Hello Cue'),
)
```

---

## Setup neste projeto

- `cue: ^0.3.1` já está no `pubspec.yaml`.
- Requer SDK Dart `>=3.10.8`. O ambiente atual usa **Flutter 3.41 / Dart 3.11**, então é compatível.
- Import único: `import 'package:cue/cue.dart';`

---

## Sintaxe: dot-shorthand vs. explícita

A documentação oficial do `cue` usa o **dot-shorthand** do Dart 3.10+
(`.smooth()`, `.fadeIn()`, `.tween(...)`, `.topLeft`). Esse recurso só é
habilitado quando o _language version_ do arquivo é ≥ 3.10.

⚠️ **Neste projeto o `pubspec.yaml` declara `sdk: ">=3.0.3 <4.0.0"`**, o que fixa o
language version padrão dos arquivos em **3.0** — onde o dot-shorthand **não existe**.
Portanto, neste repositório usamos sempre a **forma explícita**:

| Dot-shorthand (docs) | Forma explícita (use aqui)    |
| -------------------- | ----------------------------- |
| `.smooth()`          | `CueMotion.smooth()`          |
| `.fadeIn()`          | `Act.fadeIn()`                |
| `.slideY(from: 0.2)` | `Act.slideY(from: 0.2)`       |
| `.tween(a, b)`       | `AnimatableValue.tween(a, b)` |
| `.fixed(v)`          | `AnimatableValue.fixed(v)`    |
| `.key(1.2)`          | `Keyframe(1.2)`               |
| `.key(1.2, at: .4)`  | `FKeyframe(1.2, at: 0.4)`     |
| `.topLeft`           | `Alignment.topLeft`           |

> A extensão `200.ms` (e `2.s`) **funciona** normalmente — é uma extension comum,
> não depende do language version.
>
> Se quiser usar o dot-shorthand idiomático, basta subir o limite inferior do SDK
> no `pubspec.yaml` para `>=3.10.0 <4.0.0`. É puramente aditivo (não quebra código
> existente), mas é uma mudança global — por isso optamos por não fazer aqui.

---

## Cue — os gatilhos

Escolha o factory conforme o gatilho. **Direção importa**: alguns só vão para
frente, outros revertem.

| Factory                | Gatilho                | Direção                                      |
| ---------------------- | ---------------------- | -------------------------------------------- |
| `Cue.onMount`          | widget entra na árvore | frente (1x; pode repetir)                    |
| `Cue.onToggle`         | `bool toggled` muda    | frente quando `true`, reverso quando `false` |
| `Cue.onChange`         | `value` muda           | reinicia do 0 e vai pra frente               |
| `Cue.onHover`          | ponteiro entra/sai     | frente no enter, reverso no exit             |
| `Cue.onFocus`          | ganha/perde foco       | frente no focus, reverso no blur             |
| `Cue.onScroll`         | posição de scroll      | "scrubbed" contínuo                          |
| `Cue.onScrollVisible`  | entra/sai do viewport  | progride conforme visibilidade               |
| `Cue.onProgress`       | `Listenable` externo   | segue o progresso externo                    |
| `Cue.indexed`          | `IndexedCueController` | sequências/listas escalonadas                |
| `Cue(controller: ...)` | imperativo total       | você chama `forward()`, `reverse()`, etc.    |

### Parâmetros notáveis

- **`Cue.onMount`**: `repeat` (loop), `reverseOnRepeat` (ping-pong), `repeatCount`
  (nº finito), `reverseMotion`, `onEnd`. Ótimo para **loaders/pulsos/splash**.
- **`Cue.onToggle`**: `toggled` (obrigatório), `motion`, `reverseMotion`,
  `skipFirstAnimation`, `onEnd`.
- **`Cue.onChange`**: `value` (obrigatório), `fromCurrentValue` (transição suave a
  partir do valor atual), `skipFirstAnimation`.
- **`Cue.onHover`**: `cursor`, `opaque`.
- **`Cue.onScrollVisible`**: `enabled`.

### Exemplos

```dart
// Toggle: expandir / colapsar
Cue.onToggle(
  toggled: isExpanded,
  motion: CueMotion.smooth(),
  reverseMotion: CueMotion.snappy(),
  child: Column(
    children: [
      Actor(acts: [Act.rotate(to: 180)], child: const Icon(Icons.expand_more)),
      Actor(
        delay: 50.ms,
        acts: [Act.fadeIn(), Act.slideY(from: 0.15)],
        child: const Text('Detalhes'),
      ),
    ],
  ),
)

// Hover (desktop/web)
Cue.onHover(
  motion: CueMotion.interactive(),
  acts: [Act.scale(to: 1.02)],
  child: const Chip(label: Text('Hover me')),
)

// onChange: re-anima quando o valor muda
Cue.onChange(
  value: currentTab,
  motion: CueMotion.smooth(),
  fromCurrentValue: true,
  acts: [Act.fadeIn(), Act.slideY(from: 0.08)],
  child: Text(labels[currentTab]),
)

// onScrollVisible: revela ao entrar na tela
Cue.onScrollVisible(
  acts: [
    Act.slide(from: const Offset(-0.6, 0), reverse: ReverseBehavior.to(const Offset(0, 0.8))),
    Act.scale(from: 0.85),
    Act.fadeIn(),
  ],
  child: const BigCard(),
)
```

---

## Actor — o renderizador

`Actor` aplica um ou mais `Act`s ao `child`, usando o `Cue` ancestral.

Regras:

- **`Actor` é passivo**: sem um `Cue` ancestral, lança erro.
- Vários `Act`s por `Actor` são permitidos — **mas só um por "key"**.
  Ex.: todas as variantes de slide (`slide`, `slideX`, `slideY`, `slideUp`, …)
  compartilham a key `Slide` e **não podem coexistir** no mesmo `Actor`.
- **Ordem importa**: clip antes de transform ≠ transform antes de clip.
- Precedência de motion: `Act.motion` > `Actor.motion` > `Cue.motion`.
- `reverseMotion` não é herdado do `Cue` quando `Actor.motion` está setado: o
  `motion` vale para os dois sentidos a menos que `reverseMotion` seja explícito.

Atalho inline via extension em `Widget`:

```dart
ElevatedButton(onPressed: onPressed, child: const Text('Salvar'))
    .act([Act.fadeIn(), Act.slideUp()]);
```

---

## Act — todos os efeitos

Cada `Act` descreve **uma** propriedade animada. Aceitam `motion`, `delay` e
`reverse` (exceto onde indicado). Defaults de `from` costumam ser a identidade
(sem transformação), então muitas vezes você só informa `to` (ou nada).

### Transform — posição e escala

- `Act.scale(from: 1.0, to: 1.2, alignment: ...)` — presets `Act.zoomIn()` (→1.1), `Act.zoomOut()` (→0.8)
- `Act.rotate(from: 0, to: 180, unit: ..., axis: ..., alignment: ...)` — graus por padrão
- `Act.rotate3D(to: Rotation3D(x: 90))`, `Act.flipX()`, `Act.flipY()` — perspectiva 3D
- `Act.rotateLayout(to: 90)` — gira recalculando o layout (mais caro; prefira `rotate`)
- `Act.translate(from: Offset.zero, to: Offset(100, 0))` — em pixels
  - `Act.translateX()`, `Act.translateY()`, `Act.translateFromGlobal(offset: ...)`,
    `Act.translateFromGlobalRect(rect)`, `Act.translateFromGlobalKey(key)`
- `Act.slide(from: Offset(0,1))` — desloca por **fração do tamanho** do widget
  - `Act.slideUp()`, `Act.slideDown()`, `Act.slideFromLeading()`,
    `Act.slideFromTrailing()`, `Act.slideX(from: -1)`, `Act.slideY(from: 0.5)`
- `Act.stretch(to: Stretch(x: 1.2, y: 0.8))` — escala eixos independentes
- `Act.skew(to: Skew(x: 0.3))`
- `Act.transform(to: matrix4)` — `Matrix4` custom
- `Act.parallax(slide: 0.5, axis: Axis.vertical)` — paralaxe ligado ao scroll/timeline

### Visual — opacidade e filtros

- `Act.opacity(from: 0.0, to: 1.0)` — presets `Act.fadeIn(from: 0.0)`, `Act.fadeOut(from: 1.0)`
- `Act.blur(from: 0.0, to: 10.0)` — presets `Act.focus(from: 10)` (desfoca→nítido),
  `Act.unfocus(to: 10)` (nítido→desfoca)
- `Act.backdropBlur(from: 0, to: 10, blendMode: ...)` — desfoca o que está **atrás**
- `Act.colorTint(from: Colors.transparent, to: color)` — overlay de cor

### Layout — tamanho e clipping

- `Act.sizedClip(from: NSize, to: NSize, alignment: ..., clipBehavior: ...)`
  - `NSize.width(200)`, `NSize.height(double.infinity)`, `NSize.square(80)`,
    `NSize(w: 300, h: null)`, `NSize.childSize`, `NSize.zero`, `NSize.infinity`
- `Act.sizedBox(width: AnimatableValue.tween(80, 200), height: AnimatableValue.fixed(100))`
- `Act.fractionalSize(widthFactor: AnimatableValue.tween(0.2, 1.0), heightFactor: ...)`
- `Act.clipHeight(fromFactor: 0.0, toFactor: 1.0, alignment: ...)` — corta por fração da altura
- `Act.clipWidth(fromFactor: 0.0, toFactor: 1.0)`
- `Act.clip(borderRadius: BorderRadius.circular(12), useSuperellipse: false)`
- `Act.circularClip(alignment: Alignment.topLeft)` — revelar/esconder circular
- `Act.padding(from: EdgeInsets.zero, to: EdgeInsets.all(16))`
- `Act.align(from: Alignment.center, to: Alignment.topLeft)`

### Decoração e estilo

- `Act.decorate(...)` — cada propriedade aceita `AnimatableValue.tween()` ou `.fixed()`:
  `color`, `borderRadius`, `border`, `boxShadow`, `gradient`, além de `shape`, `position`.
  ```dart
  Act.decorate(
    color: AnimatableValue.tween(Colors.white, Colors.blue.shade50),
    borderRadius: AnimatableValue.tween(
      BorderRadius.circular(12),
      BorderRadius.circular(40),
    ),
  )
  ```
- `Act.textStyle(from: s1, to: s2)` — interpola `TextStyle`
- `Act.iconTheme(from: t1, to: t2)` — interpola `IconThemeData`

### Posicional e especializados

- `Act.position(...)` / `Position.fill(...)` / `Position(start: 10, top: 20, width: 100)` — anima `Positioned` em `Stack`
- `CardAct(...)` — anima `Card` (elevation, color, shadowColor, borderRadius, margin) — prefira o widget `CardActor`
- `PaintAct(painter: ...)` — passa progresso 0→1 a um `CustomPainter` (`paintOnTop: true` para frente)
- `PathMotionAct(path: ...)` — move o widget ao longo de um `Path` (`rotateToTangent: true` aponta na direção)

---

## CueMotion — timing e física

Em UI, **molas (spring)** são o padrão: lidam bem com interrupções.

### Presets de mola

| Preset                                                    | Caráter                                      |
| --------------------------------------------------------- | -------------------------------------------- |
| `CueMotion.smooth()`                                      | rápido, sem overshoot — **melhor padrão**    |
| `CueMotion.snappy()`                                      | quase instantâneo — micro-interações         |
| `CueMotion.bouncy()`                                      | overshoot visível — destaque/diversão        |
| `CueMotion.gentle()`                                      | lento e suave — ambiente/fundo               |
| `CueMotion.wobbly()`                                      | oscilação exagerada — use com parcimônia     |
| `Spring.interactive()`                                    | resposta de drag/hover (via classe `Spring`) |
| `CueMotion.spatial()` / `spatialSlow()` / `spatialFast()` | layout (Material)                            |
| `CueMotion.effect()` / `effectSlow()` / `effectFast()`    | decorativo (Material)                        |

> `interactive` só existe como `Spring.interactive()` (não há `CueMotion.interactive`).

### Mola customizada

```dart
CueMotion.spring(duration: 400.ms, bounce: 0.2)   // duração + bounce
Spring.smooth(dampingRatio: 0.85)                 // ajuste fino de um preset
Spring.withDampingRatio(stiffness: 500, ratio: 0.8)
```

### Timed (duração fixa + curva)

```dart
CueMotion.linear(250.ms)
CueMotion.easeIn(250.ms)
CueMotion.easeOut(250.ms)
CueMotion.easeInOut(300.ms)
CueMotion.easeOutBack(200.ms)   // overshoot
CueMotion.easeInBack(200.ms)    // antecipação
CueMotion.fastOutSlowIn(200.ms) // curva Material
CueMotion.curved(200.ms, curve: Curves.elasticOut)
CueMotion.threshold(200.ms, breakpoint: 0.5) // pula pro fim ao cruzar 50%
```

> O tempo real de uma timed motion escala com `|fim − início|` — começar na
> metade (0.5→1.0) usa metade da duração.

---

## Keyframes — animação multi-etapa

Use quando a transição precisa de **mais de um alvo**. A maioria dos `Act`s tem
um construtor `.keyframed(...)` (`ScaleAct.keyframed`, `TranslateAct.keyframed`, …).

### Baseado em motion (cada frame pode ter sua própria motion)

```dart
Actor(
  acts: [
    ScaleAct.keyframed(
      frames: Keyframes([
        Keyframe(0.92),
        Keyframe(1.06, motion: CueMotion.bouncy()),
        Keyframe(1.0),
      ], motion: CueMotion.smooth()),
    ),
  ],
  child: child,
)
```

### Fracionário (posições 0–1 dentro de uma duração)

```dart
Actor(
  acts: [
    TranslateAct.keyframed(
      frames: Keyframes.fractional([
        FKeyframe(const Offset(0, 24), at: 0.0),
        FKeyframe(const Offset(0, -8), at: 0.7),
        FKeyframe(Offset.zero, at: 1.0),
      ], duration: 450.ms),
    ),
  ],
  child: child,
)
```

> Cada keyframe é um **alvo a alcançar**, não um ponto de partida.

---

## Reverse, delay e stagger

`Act`s, `Actor`s e `Cue`s contribuem com timing.

- **`reverse`** (em cada `Act`), tipo `ReverseBehavior`:
  - `ReverseBehavior.mirror()` _(padrão)_ — volta ao `from`
  - `ReverseBehavior.exclusive()` — só toca no reverso (ida é instantânea)
  - `ReverseBehavior.none()` — só toca na ida (reverso instantâneo)
  - `ReverseBehavior.to(valor)` — reverte para um alvo custom
  - `mirror()` e `to()` aceitam `motion:` e `delay:` (única forma de motion/delay de reverso por-act)
  - Em acts **keyframed**, use `KFReverseBehavior` (mesmo formato; `to()` recebe `Keyframes<T>`; só `delay`)
- **`delay`** soma com o `delay` do `Actor` (empilham).
- **Stagger**: dê `delay`s crescentes a `Actor`s irmãos sob o **mesmo** `Cue`.

```dart
Actor(
  motion: CueMotion.smooth(),
  reverseMotion: CueMotion.linear(160.ms),
  delay: 80.ms,
  acts: [
    Act.fadeIn(reverse: ReverseBehavior.mirror(delay: 40.ms)),
    Act.scale(to: 1.06, reverse: ReverseBehavior.to(0.98, motion: CueMotion.bouncy())),
  ],
  child: child,
)
```

---

## Controllers e uso imperativo

Prefira os factories. Use controllers quando precisar orquestrar manualmente.

- `CueController(vsync: this, motion: ...)` — `AnimationController` sobre uma
  `CueTimeline`. A **duração vem da motion** (não set direto).
- Alto nível: passe em `Cue(controller: ...)` e deixe os `Actor`s consumirem.
- Baixo nível: `obtainTrack`, `tweenTrack`, `keyframedTrack` para animações tipadas.
- Navegação/sequência: `CuePageController`, `CueTabController`, `CueIndexController`,
  `IndexedCueController`, `SelfAnimatedCue`.

```dart
late final CueController controller;

@override
void initState() {
  super.initState();
  controller = CueController(vsync: this, motion: CueMotion.smooth());
}

@override
Widget build(BuildContext context) => Cue(
  controller: controller,
  acts: [Act.fadeIn(), Act.slideY(from: 0.2)],
  child: child,
);

@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

PageView com `Cue.indexed`:

```dart
final controller = CuePageController(viewportFraction: 0.8);

PageView.builder(
  controller: controller,
  itemCount: pages.length,
  itemBuilder: (context, index) => Cue.indexed(
    controller: controller,
    index: index,
    child: Column(children: [
      Actor(acts: [Act.fadeIn(), Act.slideY(from: 0.12)], child: Text(pages[index].title)),
      Actor(delay: 60.ms, acts: [Act.scale(from: 0.96), Act.fadeIn()], child: card),
    ]),
  ),
)
```

---

## Helpers de alto nível

- **`showCueDialog`** / `CueDialogRoute` — transições de diálogo com Cue:
  ```dart
  showCueDialog(
    context: context,
    motion: CueMotion.smooth(),
    reverseMotion: CueMotion.snappy(),
    builder: (context) => Actor(
      acts: [Act.fadeIn(), Act.slideY(from: 0.12), Act.scale(from: 0.9)],
      child: const AlertDialog(title: Text('Olá')),
    ),
  );
  ```
- **`CueModalTransition`** — expande conteúdo modal a partir de um gatilho; o
  `builder` recebe o `Rect` do gatilho (anima posição/tamanho a partir da origem).
  Ideal para **menus de FAB estilo Slack** e **menus de contexto iOS**.
- **`CueModalRouteMixin`** — integração com rotas dirigidas por Cue.
- **`CueDragScrubber`** — "scrubbing" por gesto de arrastar:
  ```dart
  Cue(
    controller: _controller,
    child: CueDragScrubber(
      scrubForwardDirection: CueScrubAxis.down, // .start/.end ou .left/.right/.up/.down
      distance: 200,                            // sempre positivo
      child: child,
    ),
  )
  ```
- **`CueFlexibleSpaceBar`** — substituto de `FlexibleSpaceBar` em `SliverAppBar`,
  dirigido pelo progresso de colapso.
- **`TweenActor<T>`** — anima um valor custom e renderiza via builder.
- **Actors compostos**: `PositionedActor`, `DecoratedBoxActor`, `CardActor`, `PaintActor`.

---

## Receitas práticas (o que dá pra fazer)

> Estas receitas estão **implementadas** em
> [lib/ui/views/cue_test/](../lib/ui/views/cue_test/) — abra a `CueTestView` para ver rodando.

| #   | Efeito                                      | Gatilho + Acts principais                                                                   |
| --- | ------------------------------------------- | ------------------------------------------------------------------------------------------- |
| 1   | **Entrada escalonada** (splash de conteúdo) | `onMount` + `Actor`s com `delay` crescente (`fadeIn`+`slideY`+`scale`)                      |
| 2   | **Botão com bounce ao tocar**               | `onToggle` no estado de "pressed" + `ScaleAct.keyframed`                                    |
| 3   | **Painel expansível**                       | `onToggle` + `clipHeight` + `fadeIn` + ícone `rotate(180)`                                  |
| 4   | **Menu FAB radial**                         | `onToggle` + por item `translate(to:)`+`scale(from:0)`+`fadeIn`; ícone central `rotate(45)` |
| 5   | **Flip 3D de card**                         | `onToggle` + `flipY()`                                                                      |
| 6   | **Caixa que se transforma**                 | `onToggle` + `decorate(color/borderRadius)` + `ScaleAct.keyframed`                          |
| 7   | **Foco/desfoque**                           | `onToggle` + `blur` (ou `focus`/`unfocus`)                                                  |
| 8   | **Revelar ao rolar**                        | `onScrollVisible` + `slide`+`scale`+`fadeIn`                                                |
| 9   | **Troca de número**                         | `onChange(value:)` + `fadeIn`+`slideY`                                                      |
| 10  | **Loader pulsante** (splash)                | `onMount(repeat: true, reverseOnRepeat: true)` + `scale`                                    |
| 11  | **Diálogo animado**                         | `showCueDialog` + `Actor` no conteúdo                                                       |
| 12  | **Hover (desktop/web)**                     | `onHover` + `scale` + `decorate`                                                            |

---

## DevTools

Durante o desenvolvimento, habilite o scrubber do Cue (envolva em `kDebugMode`):

```dart
MaterialApp(
  builder: (context, child) {
    if (kDebugMode) return CueDebugTools(child: child!);
    return child!;
  },
)
```

Cada `Cue` se registra ao completar a ida; o scrubber permite arrastar a timeline
para frente e para trás para inspeção.

---

## Regras e armadilhas

- ⚠️ **Overshoot × propriedades com limites rígidos.** Molas subamortecidas
  (`bouncy`, `wobbly`, `gentle`, `spatial*`, `effectFast` — `dampingRatio < 1`)
  ultrapassam o alvo. Em props **sem clamp** isso quebra em runtime:
  - `opacity`/`fadeIn`/`fadeOut` → `FadeTransition` exige `[0, 1]`;
  - `blur`/`backdropBlur` → sigma não pode ser negativo;
  - `boxShadow.blurRadius` → não pode ser negativo (não anime a partir de lista vazia).

  Regra prática: use a mola só em `scale`/`translate`/`slide`/`rotate` e dê às
  props limitadas uma motion **criticamente amortecida** (`smooth`, `snappy`,
  `effect`, `linear`/`ease*`), via override por-act:

  ```dart
  acts: [
    Act.scale(from: 0.5),                                // mola ok
    Act.fadeIn(motion: CueMotion.smooth()),             // sem overshoot
  ]
  ```

  Para hover/realce, prefira `colorTint` (faz clamp de cor) a `boxShadow` animado.

- `Actor` **sem `Cue` ancestral lança erro**.
- **Um `Act` por key** por `Actor`; variantes de slide dividem a mesma key.
- **Ordem dos acts** muda o resultado (clip × transform).
- `onScrollVisible` precisa estar dentro de um `Scrollable` (ex.: `ListView`).
- Em slivers, anime o widget **não-sliver** dentro do sliver; para headers use `CueFlexibleSpaceBar`.
- `CueFlexibleSpaceBar` não reage a mudança de `expandedHeight` em runtime (use `ValueKey`).
- Disponível em Android, iOS, Web, Windows, macOS e Linux.
  </content>
  </invoke>

<invoke name="TodoWrite">
<parameter name="todos">[{"content": "Install cue package and inspect real API source", "status": "completed", "activeForm": "Installing cue and inspecting API"}, {"content": "Write rd_docs/cue.md documentation of all possibilities", "status": "completed", "activeForm": "Writing cue documentation"}, {"content": "Build cue_test_view with components folder", "status": "in_progress", "activeForm": "Building cue_test_view"}, {"content": "Register route + run build_runner + analyze", "status": "pending", "activeForm": "Registering route and running codegen"}]
