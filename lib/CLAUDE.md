# lib — Visão Geral

## Verificação de CLAUDE.md em Subdiretórios (OBRIGATÓRIO)

Antes de criar ou editar qualquer arquivo em um subdiretório, verifique se existe um `CLAUDE.md` naquele diretório e leia-o antes de prosseguir.

---

## Fluxo de Dados

```
Firestore → Service → ViewModel → View
```

Nunca pule camadas.

---

## Estrutura e CLAUDE.md por diretório

| Diretório | Responsabilidade | Referência |
|-----------|-----------------|------------|
| `app/` | Arquivos gerados pelo Stacked — nunca editar manualmente | [app/CLAUDE.md](app/CLAUDE.md) |
| `firestore/` | Queries e conversão Map → Model | [firestore/CLAUDE.md](firestore/CLAUDE.md) |
| `services/` | Singletons — intermediam ViewModel e Firestore | [services/CLAUDE.md](services/CLAUDE.md) |
| `models/` | Entidades de domínio persistidas | [models/CLAUDE.md](models/CLAUDE.md) |
| `schemas/` | DTOs temporários entre camadas | [schemas/CLAUDE.md](schemas/CLAUDE.md) |
| `utils/` | Wrappers de pacotes externos e helpers globais | [utils/CLAUDE.md](utils/CLAUDE.md) |
| `ui/` | Views, ViewModels, componentes, dialogs, bottom sheets | [ui/CLAUDE.md](ui/CLAUDE.md) |
| `exceptions/` | `AppError` — lançado por Services, capturado por ViewModels | — |
