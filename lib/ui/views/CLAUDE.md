# Views e ViewModels

## ViewModel — Regras

- Funções chamadas diretamente pela View devem começar com `handle` (ex.: `handleLogin`).
- Se precisar rodar lógica na inicialização, crie `init()` e chame no construtor.
- Nunca acesse Firestore diretamente — chame o Service.
- Nunca chame funções de `lib/firestore/` diretamente — passe por um método do Service.
- Não use `rebuildUi()` — use `notifyListeners()`.
- Ouça mudanças de Service via `ValueNotifier` com `addListener`/`removeListener` no `dispose`.

```dart
class HomeViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _log = getLogger('HomeViewModel');

  HomeViewModel() {
    _userService.user.addListener(_onUserChanged);
  }

  UserModel? get user => _userService.user.value;

  void _onUserChanged() => notifyListeners();

  @override
  void dispose() {
    _userService.user.removeListener(_onUserChanged);
    super.dispose();
  }
}
```

## View — Regras

- Nunca coloque lógica condicional na View. Toda decisão de UI fica na ViewModel via getters.
- A View apenas consome — sem `if`, sem `switch`, sem operadores ternários de lógica de negócio.

```dart
// ✅ Correto — View só consome
onTap: () => viewModel.handleCarroPCD(true),

// ❌ Errado — lógica na View
onTap: () {
  viewModel.isPCD = true;
  viewModel.notifyListeners();
}
```

## UI condicional via getters

Quando a View precisa exibir valores diferentes dependendo de estado, exponha getters na ViewModel.

```dart
// ViewModel
String get title => switch (userStatus) {
  UserStatus.pendingApproval => 'Cadastro em análise',
  UserStatus.rejected        => 'Cadastro rejeitado',
  UserStatus.approved        => '',
  _                          => '',
};

ImageEnum? get imageEnum {
  if (userStatus == UserStatus.pendingApproval) return ImageEnum.ampulheta;
  if (userStatus == UserStatus.rejected) return ImageEnum.redWarning;
  return null;
}

void handleOnPressed() {
  if (userStatus == UserStatus.rejectedRetry) resendRegistration();
  else if (userStatus == UserStatus.rejected) talkToSupport();
}

// View — sem lógica condicional
ImageUtil(viewModel.imageEnum!),
Text(viewModel.title),
AppButton(onPressed: viewModel.handleOnPressed),
```

---

## Callbacks entre Telas

Use callbacks quando precisar passar uma função entre telas, dialogs ou bottom sheets. Declare como opcional (`?`) e verifique antes de chamar.

```dart
// View que recebe o callback
class DependentRegisterView extends StackedView<DependentRegisterViewModel> {
  final Function(DependentModel)? registerCallback;

  const DependentRegisterView({Key? key, this.registerCallback}) : super(key: key);

  @override
  DependentRegisterViewModel viewModelBuilder(BuildContext context) =>
      DependentRegisterViewModel(registerCallback);
}

// ViewModel que usa o callback
class DependentRegisterViewModel extends BaseViewModel {
  final Function(DependentModel)? registerCallback;
  DependentRegisterViewModel(this.registerCallback);

  void onFinish() {
    if (registerCallback != null) registerCallback!(dependentModel);
  }
}

// Como navegar passando o callback
_navigationService.navigateToDependentRegisterView(
  registerCallback: (dependent) => handleRegistration(dependent),
);
```

---

## Navegação (Stacked)

Sempre use os métodos tipados gerados automaticamente. Nunca use `navigateTo` com `Routes` e `arguments` manuais.

```dart
// ✅ Correto — métodos tipados
_navigationService.navigateToProfileView();
_navigationService.navigateToProfileView(userId: userId);
_navigationService.replaceWithProfileView();
_navigationService.popUntil((route) => Routes.homeView == route.settings.name);
_navigationService.clearStackAndShowView(const HomeView());

// ❌ Proibido
_navigationService.navigateTo(Routes.profileView, arguments: ProfileViewArguments(userId: userId));
```

---

## Formulários

- Validadores estáticos ficam em `lib/utils/validators.dart`.
- Máscaras ficam em `lib/utils/easy_mask.dart`.

```dart
// View
Form(
  key: viewModel.formKey,
  child: CustomTextFormField(
    label: 'Celular (WhatsApp)',
    keyboardType: TextInputType.phone,
    inputFormatters: [phoneMaskFormatter],
    controller: viewModel.celularController,
    validator: Validators.phone,
  ),
)

// ViewModel
final formKey = GlobalKey<FormState>();
final celularController = TextEditingController();

void handleSubmit() {
  if (!formKey.currentState!.validate()) return;
  // continuar
}
```

Validação customizada (sem validator estático):

```dart
// View
CustomTextFormField(
  label: 'Celular',
  controller: viewModel.celularController,
  validationMessage: viewModel.phoneErrorMessage,
)

// ViewModel
String? phoneErrorMessage;

Future<void> handleSubmit() async {
  try {
    // lógica
  } on AppError catch (e) {
    _log.e(e);
    phoneErrorMessage = e.message;
    notifyListeners();
  }
}
```
