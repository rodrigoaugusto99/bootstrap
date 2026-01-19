import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/app/app.router.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/services/api_service.dart';
import 'package:bootstrap/services/user_service.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import '../firestore/user.dart' as firestore;

class AuthService {
  User? currUser = FirebaseAuth.instance.currentUser;
  final _log = getLogger('AuthService');
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();

  // INIT

  Future<void> init() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        _log.i('User is currently signed out!');
        currUser = null;
      } else {
        _log.i('User ${user.uid} is signed in!');
        currUser = user;
        currUser!
            .getIdToken()
            .then((value) => _log.i('User token: $value'))
            .catchError((e) {
          signOut();
        });
      }
    });
  }

  // SETUP USER LOGGED IN
  Future<void> setupUserLoggedIn() async {
    //_log.v('setupUserLoggedIn');
    if (currUser == null) {
      _log.e('currUser is null');
      return;
    }
    try {
      // if (!(await userExists(userId: currUser!.uid))) {
      //   await createUser(userId: currUser!.uid, map: {});
      // }
      await locator<UserService>().setUser(currUser!.uid);
      //await locator<InAppPurchaseService>().init();
      //await locator<NotificationService>().initNotifications();
      _navigationService.clearStackAndShow(Routes.homeView);
      // _log.wtf('terminou o setupUserLoggedIn');
    } catch (e, stackTrace) {
      //_log.e('Erro no setupUserLoggedIn: $e\n$stackTrace');
      _log.e(
          'Erro no setupUserLoggedIn: erro: $e\n\n\n\nstackTrace: $stackTrace');
    }
  }

//ENTRAR COM EMAIL E SENHA
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      currUser = userCredential.user;

      await createUserProfile();

      await setupUserLoggedIn();
    } on AppError {
      rethrow;
    } on FirebaseAuthException catch (e) {
      _log.e(e);
      throw AppError(message: INVALID_CREDENTIAL);
    } on Exception catch (e) {
      _log.e(e);
      throw AppError(message: 'Erro ao efetuar login');
    }
  }

  //CADASTRAR COM EMAIL E SENHA

  Future<void> registerEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      currUser = userCredentials.user;

      await createUserProfile();

      await setupUserLoggedIn();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw AppError(
            message: WEAK_PASSWORD,
          );
        case 'email-already-in-use':
          throw AppError(
            message: EMAIL_ALREADY_IN_USE,
          );
      }
    } catch (e) {
      _log.e(e);
    }
  }

// SIGN IN ANONYMOUSLY

  /*
  Future<void> signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      currUser = userCredential.user;
      await createUserProfile(accountOwnerId: null);
      setSharedPreferencesOnBoarding();

      await setupUserLoggedIn();
      _log.i("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          _log.e("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          _log.e("Unknown error.");
      }
    }
  }
   */

  //TRANSFORMAR ANONIMO EM NORMAL

  /*
  Future<void> authenticateAnonymousUser({
    required String name,
    required String email,
    required String password,
    required bool isGoogle,
    required bool isApple,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || !user.isAnonymous) {
        throw Exception('Nenhum usuário anônimo encontrado');
      }

      if (isGoogle) {
        // Conversão para conta Google
        await _convertToGoogle(user, name);
      } else if (isApple) {
        // Conversão para conta Apple
        await _convertToApple(user, name);
      } else {
        // Conversão para email/senha
        await _convertToEmailPassword(user, email, password, name);
      }

      // Atualiza o nome do usuário (se fornecido)
      if (name.isNotEmpty) {
        await user.updateDisplayName(name);
      }
      if (currUser != null && currUser!.email != null) {
        //await locator<UserService>().updateUserField('email', currUser!.email!);
      }

      if (currUser != null && currUser!.displayName != null) {
        // await locator<UserService>()
        //     .updateUserField('displayName', currUser!.displayName!);
      }

      _log.i('Conta convertida com sucesso!');

      // Atualiza os dados no Firestore se necessário
      // await _updateUserDataInFirestore(user.uid, email, name);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          _log.e("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          _log.e("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          _log.e("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          throw AppError(message: 'Já existe uma conta com este email');
        case "email-already-in-use":
          _log.e("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          throw AppError(message: 'Já existe uma conta com este email');
        default:
          _log.e("Unknown error.");
      }
      rethrow;
    }
  }

  Future<void> _convertToEmailPassword(
      User user, String email, String password, String name) async {
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.linkWithCredential(credential);

    // Envia email de verificação
    // await user.sendEmailVerification();
  }

  Future<void> _convertToGoogle(User user, String name) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();

    if (googleAccount == null) {
      throw Exception('Login com Google cancelado');
    }

    final googleAuth = await googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await user.linkWithCredential(credential);
    await user.reload();

    // Pega a referência ATUALIZADA do usuário
    final updatedUser = FirebaseAuth.instance.currentUser!;

    // Define o displayName (prioriza o nome do Google, depois o parâmetro name)
    final String displayName = updatedUser.displayName ?? name;
    if (displayName.isNotEmpty && updatedUser.displayName != displayName) {
      await updatedUser.updateDisplayName(displayName);
    }
  }

  Future<void> _convertToApple(User user, String name) async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    if (currUser != null) {
      final displayName =
          ("${appleCredential.givenName ?? "Apple"} ${appleCredential.familyName ?? "User"}")
              .trim();
      _log.i("Updating display name to $displayName");
      await currUser!.updateDisplayName(displayName).catchError(
            (e) => _log.e("Error updating display name: ${e.toString()}"),
          );
    }

    await user.linkWithCredential(oauthCredential);
  }
  */

  //ENVIAR CÓDIGO SMS

  /*
  Future<void> sendCode({
    required String phoneNumber,
    int? resendToken,
    required Function(CodeSentParams params) onSent,
    Function(String message)? onError,
  }) async {
    if (resendToken == null) {
      _log.i('sending code');
    } else {
      _log.i('resending code');
    }
    String formattedPhoneNumber = convertPhoneNumber(phoneNumber);
    _log.i('Formatted phone number: $formattedPhoneNumber');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: formattedPhoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        _log.i('Verification completed');

        // Sign the user in (or link) with the auto-generated credential
        await FirebaseAuth.instance.signInWithCredential(credential);
        currUser = userCredential.user;
      },
      verificationFailed: (FirebaseAuthException e) {
        _log.e('Error verifying phone number: ${e.message}');
        String errorMessage = 'Erro ao enviar código';

        if (e.code == 'invalid-phone-number') {
          errorMessage = 'Número de telefone inválido';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'Muitas tentativas. Tente novamente mais tarde';
        }

        if (onError != null) {
          onError(errorMessage);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        if (resendToken == null) {
          _log.i('Code sent to phone number: $phoneNumber');
        } else {
          _log.i('Code resent to phone number: $phoneNumber');
        }

        final params = CodeSentParams(
          verificationId: verificationId,
          resendToken: resendToken,
        );

        onSent(params);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _log.i('Code auto retrieval timeout: $verificationId');
      },
    );
  }
  */

  // VEFICAR CÓDIGO SMS

  /*
    verifyCode(VerifyCodeParams param) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: param.verificationId,
        smsCode: param.smsCode,
      );

      // Sign the user in (or link) with the credential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      currUser = userCredential.user;
    } on Exception catch (e) {
      //todo: throw AppErrors com mensagens de acordo com o que aconteceu
      _log.e('Error verifying code: $e');
      throw AppError(message: 'Error verifying code');
    }
    return null;
  }
  */

// CRIAR USUARIO NO FIRESTORE

  Future<void> createUserProfile() async {
    try {
      if (currUser == null) return;

      String uid = currUser!.uid;

      String newName = (currUser!.displayName)?.trim() ?? '';

      // Dados do perfil do usuário
      final userProfile = {
        'name': newName,
        'email': currUser!.email,
        'emailUpperCase': currUser!.email?.toUpperCase(),
        'nameUpperCase': newName.toUpperCase(),
        'createdAt': FieldValue.serverTimestamp(),
      };
      await firestore.createUser(
        userMap: userProfile,
        userId: uid,
      );
    } catch (e) {
      _log.e("Erro ao criar perfil do usuário: $e");
      throw AppError(message: 'Erro ao cadastrar usuário');
    }
  }

  // LOGOUT

  Future signOut() async {
    _log.i('Signing out');
    // await locator<NotificationService>().removeFcmTokenFromFirestore();
    //await locator<NotificationService>().dispose();
    currUser = null;
    await FirebaseAuth.instance.signOut();
    // locator<UserService>().unSetUser();
    locator.pushNewScope();
    locator.registerLazySingleton(() => AuthService());
    locator.registerLazySingleton(() => UserService());

    _navigationService.clearStackAndShow(Routes.loginView);
  }
}
