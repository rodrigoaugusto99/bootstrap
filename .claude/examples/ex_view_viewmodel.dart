// ❌ Errado — lógica na View
onTap: () {
  viewModel.isPCD = true;
  viewModel.notifyListeners();
}

// ✅ Correto — lógica na ViewModel
// View:
onTap: () => viewModel.toggleCarroPCD(true),

// ViewModel:
void toggleCarroPCD(bool value) {
  carroPCD = value;
  notifyListeners();
}

// ---
// ViewModel ouvindo mudanças do UserService:
class HomeViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _log = getLogger('HomeViewModel');

  HomeViewModel() {
    _userService.user.addListener(_onUserChanged);
  }

  UserModel? get user => _userService.user.value;

  void _onUserChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _userService.user.removeListener(_onUserChanged);
    super.dispose();
  }
}
