# UI — Regras e Padrões

Antes de criar ou editar qualquer arquivo neste diretório, leia este arquivo inteiro.

---

## Estrutura

```
ui/
├── common/          ← app_colors.dart, app_theme.dart, app_strings.dart
├── components/      ← componentes reutilizáveis em múltiplas telas
├── dialogs/         ← dialogs do Stacked
├── bottom_sheets/   ← bottom sheets do Stacked
└── views/           ← uma pasta por tela, com view + viewmodel (+ components locais)
```

> Componentes usados só em uma tela ficam dentro da pasta da própria view, não em `components/`.

---

## Skills — Leitura Obrigatória

OBRIGATÓRIO: antes de gerar qualquer código neste diretório, identifique o contexto abaixo e leia o SKILL.md correspondente com a ferramenta Read. Nunca gere código sem ter lido o arquivo primeiro.

| Contexto                               | Arquivo a ler                                                                          |
| -------------------------------------- | -------------------------------------------------------------------------------------- |
| Criar ou editar ViewModel              | [.claude/viewmodel/SKILL.md](../../.claude/viewmodel/SKILL.md)                         |
| Criar ou editar View ou componente     | [.claude/view/SKILL.md](../../.claude/view/SKILL.md)                                   |
| Criar ou editar Dialog ou Bottom Sheet | [.claude/dialogs_and_bottomsheets/SKILL.md](../../.claude/dialogs_and_bottomsheets/SKILL.md) |
| Criar ou editar Form                   | [.claude/forms/SKILL.md](../../.claude/forms/SKILL.md)                                 |
| Navegação entre telas                  | [.claude/navigation/SKILL.md](../../.claude/navigation/SKILL.md)                       |
| Usar Assets (imagens, SVGs)            | [.claude/assets/SKILL.md](../../.claude/assets/SKILL.md)                               |
| Toggle, seleção de opções              | [.claude/toggle_and_selection/SKILL.md](../../.claude/toggle_and_selection/SKILL.md)   |
| Callbacks entre componentes            | [.claude/callbacks/SKILL.md](../../.claude/callbacks/SKILL.md)                         |

---

## Regras Gerais

- Nunca coloque lógica condicional na View. Toda decisão de UI fica na ViewModel via getters.
- A View apenas consome — sem `if`, sem `switch`, sem operadores ternários de lógica de negócio.
- Não use `rebuildUi()`. Use `notifyListeners()`.
- Não faça comentários no código.
- Funções chamadas diretamente pela View devem começar com `handle` (ex.: `handleOnPressed`).

### UI condicional via getters

Quando a View precisa exibir valores diferentes (texto, imagem, comportamento) dependendo de um estado, exponha getters na ViewModel que encapsulam essa decisão.

```dart
// View — só consome, sem lógica
ImageUtil(viewModel.imageEnum!),
Text(viewModel.title),
AppButton(onPressed: viewModel.handleOnPressed),
```

→ [ex_viewmodel_conditional_ui.dart](../../.claude/viewmodel/references/ex_viewmodel_conditional_ui.dart)
