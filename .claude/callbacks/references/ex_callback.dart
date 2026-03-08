// ── View que recebe callback ───────────────────────────────────────────────────
class DependentRegisterView extends StackedView<DependentRegisterViewModel> {
  final Function(DependentModel)? registerCallback;

  const DependentRegisterView({Key? key, this.registerCallback}) : super(key: key);

  @override
  DependentRegisterViewModel viewModelBuilder(BuildContext context) =>
      DependentRegisterViewModel(registerCallback);
}

// ── ViewModel que usa o callback ──────────────────────────────────────────────
class DependentRegisterViewModel extends BaseViewModel {
  final Function(DependentModel)? registerCallback;

  DependentRegisterViewModel(this.registerCallback);

  void onFinish() {
    if (registerCallback != null) registerCallback!(dependentModel);
  }
}

// ── Navegando com callback ────────────────────────────────────────────────────
_navigationService.navigateToDependentRegisterView(
  registerCallback: (dependent) => handleRegistration(dependent),
);

void handleRegistration(DependentModel dependent) {
  // processar o retorno
}
