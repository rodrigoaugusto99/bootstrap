---
name: toggle_and_selection
description: Use radio buttons para seleção única e checkboxes para seleção múltipla, sempre gerenciando estado na ViewModel
---


# Toggle e Seleção

- **Radio (seleção única):** variável única, `handleToggle...` na ViewModel.
- **Checkbox (seleção múltipla):** `List`, `handleSelect...` na ViewModel.
- Sempre use `GestureDetector` com `behavior: HitTestBehavior.translucent`.

→ [ex_toggle_selection.dart](references/ex_toggle_selection.dart)
