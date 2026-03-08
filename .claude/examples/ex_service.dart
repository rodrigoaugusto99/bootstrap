// ── lib/services/user_service.dart ───────────────────────────────────────────

class UserService with ListenableServiceMixin {
  final _firestore = UserFirestore();
  final _log = getLogger('UserService');

  ValueNotifier<UserModel?> user = ValueNotifier(null);
  StreamSubscription? _userSubscription;

  // Inicia escuta do usuário logado
  Future<void> setUser(String uid) async {
    try {
      _userSubscription = await _firestore.getAndListenUserById(
        onNewSnapshot: (u) => user.value = u,
        userId: uid,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Atualização via schema
  Future<void> updateUserRegistration(UserRegistrationSchema schema) async {
    try {
      await _firestore.updateUser(
        map: schema.toMap(),
        userId: user.value!.id,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Erro genérico (vindo do Firestore)
  Future<void> fetchSomething() async {
    try {
      // ...
    } catch (e) {
      _log.e(e);
      throw AppError(message: 'Erro ao buscar dados.');
    }
  }

  // Erro com mensagem da API
  Future<void> callApi() async {
    try {
      // ...
    } catch (e) {
      _log.e(e);
      throw AppError(message: (e as ApiError).message);
    }
  }
}

// ── ViewModel capturando AppError ─────────────────────────────────────────────

Future<void> submit() async {
  try {
    await _userService.doSomething();
  } on AppError catch (e) {
    _log.e(e);
    // mostrar toast com e.message
  } catch (e) {
    _log.e(e);
  }
}
