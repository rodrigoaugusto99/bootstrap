import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/app/app.router.dart';
import 'package:bootstrap/services/api_service.dart';
import 'package:bootstrap/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

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
      _navigationService.replaceWithHomeView();
      // _log.wtf('terminou o setupUserLoggedIn');
    } catch (e, stackTrace) {
      //_log.e('Erro no setupUserLoggedIn: $e\n$stackTrace');
      _log.e(
          'Erro no setupUserLoggedIn: erro: $e\n\n\n\nstackTrace: $stackTrace');
    }
  }

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
