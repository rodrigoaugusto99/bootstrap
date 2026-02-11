---
name: flutter-navigation
description: Implements Flutter navigation using Stacked package patterns. Use when implementing navigation, routing between screens, or when the user mentions navigateTo, replaceWith, navigation service, or screen transitions in Flutter with Stacked.
---

# Flutter Navigation with Stacked

## Padrão de Navegação

Este projeto utiliza o pacote Stacked para navegação. Use sempre os métodos tipados do `NavigationService`.

## Métodos Permitidos

### Adicionar tela na pilha

```dart
_navigationService.navigateToProfileView();
```

### Substituir tela na pilha

```dart
_navigationService.replaceWithProfileView();
```

### Limpar pilha até uma tela específica

```dart
_navigationService.popUntil((route) => Routes.homeView == route.settings.name);
```

### Limpar toda a pilha e mostrar uma tela

```dart
_navigationService.clearStackAndShowView(const HomeView());
```

## ❌ Padrão Proibido

**NUNCA use** o método `navigateTo` com `Routes` e `arguments`:

```dart
// ❌ NÃO FAZER
_navigationService.navigateTo(
  Routes.conectarProceduresView,
  arguments: ConectarProceduresViewArguments(
    specialtyId: specialtyId,
    specialtyName: specialtyName,
  ),
);
```

## Passagem de Parâmetros

Quando precisar passar parâmetros, os métodos tipados do NavigationService já incluem os parâmetros necessários:

```dart
// ✅ Correto - método gerado automaticamente aceita parâmetros
_navigationService.navigateToProfileView(
  userId: userId,
  userName: userName,
);
```

## Regra Importante

Sempre utilize os métodos tipados gerados automaticamente pelo Stacked. Eles garantem type-safety e evitam erros em tempo de execução.
