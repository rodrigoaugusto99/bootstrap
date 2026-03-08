// ── ViewModel ─────────────────────────────────────────────────────────────────

UserModel get user => _userService.user.value!;

UserStatus get userStatus => user.userStatus;

String get title {
  switch (userStatus) {
    case UserStatus.pendingApproval:
      return 'Cadastro em análise';
    case UserStatus.rejected:
      return 'Cadastro rejeitado definitivamente';
    case UserStatus.rejectedRetry:
      return 'Credenciamento não encontrado';
    case UserStatus.approved:
      return '';
  }
}

ImageEnum? get imageEnum {
  if (userStatus == UserStatus.pendingApproval) {
    return ImageEnum.ampulheta;
  } else if (userStatus == UserStatus.rejected) {
    return ImageEnum.redWarning;
  } else if (userStatus == UserStatus.rejectedRetry) {
    return ImageEnum.yellowWarning;
  }
  return null;
}

void handleOnPressed() {
  if (userStatus == UserStatus.rejectedRetry) {
    resendRegistration();
  } else if (userStatus == UserStatus.rejected) {
    talkToSupport();
  }
}


// ── View ──────────────────────────────────────────────────────────────────────
// A View não tem lógica condicional — só consome os getters

ImageUtil(viewModel.imageEnum!),
Text(viewModel.title),
AppButton(onPressed: viewModel.handleOnPressed),
