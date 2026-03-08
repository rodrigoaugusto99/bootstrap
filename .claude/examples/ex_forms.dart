// ── View ──────────────────────────────────────────────────────────────────────
Form(
  key: viewModel.formKey,
  child: Column(
    children: [
      CustomTextFormField(
        label: 'Celular (WhatsApp)',
        keyboardType: TextInputType.phone,
        inputFormatters: [phoneMaskFormatter],
        controller: viewModel.celularController,
        validator: Validators.phone,
      ),
    ],
  ),
)

// ── ViewModel ─────────────────────────────────────────────────────────────────
final formKey = GlobalKey<FormState>();
final celularController = TextEditingController();

void submit() {
  if (!formKey.currentState!.validate()) return;
  // continuar
}


// ── Validação customizada (sem validator) ─────────────────────────────────────
// View:
CustomTextFormField(
  label: 'Celular',
  controller: viewModel.celularController,
  validationMessage: viewModel.phoneErrorMessage,
)

// ViewModel:
String? phoneErrorMessage;

Future<void> submit() async {
  try {
    // lógica
  } on AppError catch (e) {
    _log.e(e);
    phoneErrorMessage = e.message;
    notifyListeners();
  }
}
