// ✅ Métodos tipados gerados pelo Stacked (sempre use estes)

// Adicionar tela na pilha
_navigationService.navigateToProfileView();
_navigationService.navigateToProfileView(userId: userId);

// Substituir tela atual
_navigationService.replaceWithProfileView();

// Limpar pilha até tela específica
_navigationService.popUntil((route) => Routes.homeView == route.settings.name);

// Limpar toda a pilha e exibir tela
_navigationService.clearStackAndShowView(const HomeView());


// ❌ Padrão PROIBIDO — nunca use navigateTo com Routes e arguments manuais
_navigationService.navigateTo(
  Routes.profileView,
  arguments: ProfileViewArguments(userId: userId),
);
