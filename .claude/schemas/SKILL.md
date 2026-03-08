---
name: schemas
description: Use schemas como DTOs para estruturar a troca de dados entre camadas e funções com muitos parâmetros
---


# Schemas (DTOs)

Ficam em `lib/schemas/`. Use quando uma função recebe muitos parâmetros ou há troca estruturada entre camadas.

**Diferença:** Schemas são temporários/contratuais. Models são entidades de domínio persistidas. → [ex_schemas.dart](references/ex_schemas.dart)
