// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bootstrap/schemas/code_sent_schema.dart' as _i15;
import 'package:bootstrap/schemas/login_view_schema.dart' as _i14;
import 'package:bootstrap/ui/views/complex_register/complex_register_view.dart'
    as _i7;
import 'package:bootstrap/ui/views/enter_code/enter_code_view.dart' as _i11;
import 'package:bootstrap/ui/views/home/home_view.dart' as _i2;
import 'package:bootstrap/ui/views/login/login_view.dart' as _i4;
import 'package:bootstrap/ui/views/login_with_sms/login_with_sms_view.dart'
    as _i10;
import 'package:bootstrap/ui/views/on_boarding/on_boarding_view.dart' as _i6;
import 'package:bootstrap/ui/views/register/register_view.dart' as _i5;
import 'package:bootstrap/ui/views/startup/startup_view.dart' as _i3;
import 'package:bootstrap/ui/views/terms/terms_view.dart' as _i12;
import 'package:bootstrap/ui/views/try_staggered_animation/try_staggered_animation_view.dart'
    as _i8;
import 'package:bootstrap/ui/views/try_staggered_animation_two/try_staggered_animation_two_view.dart'
    as _i9;
import 'package:flutter/material.dart' as _i13;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i16;

class Routes {
  static const homeView = '/home-view';

  static const startupView = '/startup-view';

  static const loginView = '/login-view';

  static const registerView = '/register-view';

  static const onBoardingView = '/on-boarding-view';

  static const complexRegisterView = '/complex-register-view';

  static const tryStaggeredAnimationView = '/try-staggered-animation-view';

  static const tryStaggeredAnimationTwoView =
      '/try-staggered-animation-two-view';

  static const loginWithSmsView = '/login-with-sms-view';

  static const enterCodeView = '/enter-code-view';

  static const termsView = '/terms-view';

  static const all = <String>{
    homeView,
    startupView,
    loginView,
    registerView,
    onBoardingView,
    complexRegisterView,
    tryStaggeredAnimationView,
    tryStaggeredAnimationTwoView,
    loginWithSmsView,
    enterCodeView,
    termsView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.startupView,
      page: _i3.StartupView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i4.LoginView,
    ),
    _i1.RouteDef(
      Routes.registerView,
      page: _i5.RegisterView,
    ),
    _i1.RouteDef(
      Routes.onBoardingView,
      page: _i6.OnBoardingView,
    ),
    _i1.RouteDef(
      Routes.complexRegisterView,
      page: _i7.ComplexRegisterView,
    ),
    _i1.RouteDef(
      Routes.tryStaggeredAnimationView,
      page: _i8.TryStaggeredAnimationView,
    ),
    _i1.RouteDef(
      Routes.tryStaggeredAnimationTwoView,
      page: _i9.TryStaggeredAnimationTwoView,
    ),
    _i1.RouteDef(
      Routes.loginWithSmsView,
      page: _i10.LoginWithSmsView,
    ),
    _i1.RouteDef(
      Routes.enterCodeView,
      page: _i11.EnterCodeView,
    ),
    _i1.RouteDef(
      Routes.termsView,
      page: _i12.TermsView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.StartupView: (data) {
      final args = data.getArgs<StartupViewArguments>(
        orElse: () => const StartupViewArguments(),
      );
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.StartupView(key: args.key),
        settings: data,
      );
    },
    _i4.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.LoginView(key: args.key, schema: args.schema),
        settings: data,
      );
    },
    _i5.RegisterView: (data) {
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.RegisterView(),
        settings: data,
      );
    },
    _i6.OnBoardingView: (data) {
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.OnBoardingView(),
        settings: data,
      );
    },
    _i7.ComplexRegisterView: (data) {
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.ComplexRegisterView(),
        settings: data,
      );
    },
    _i8.TryStaggeredAnimationView: (data) {
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.TryStaggeredAnimationView(),
        settings: data,
      );
    },
    _i9.TryStaggeredAnimationTwoView: (data) {
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => const _i9.TryStaggeredAnimationTwoView(),
        settings: data,
      );
    },
    _i10.LoginWithSmsView: (data) {
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.LoginWithSmsView(),
        settings: data,
      );
    },
    _i11.EnterCodeView: (data) {
      final args = data.getArgs<EnterCodeViewArguments>(nullOk: false);
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => _i11.EnterCodeView(
            key: args.key,
            codeSentParams: args.codeSentParams,
            phoneNumber: args.phoneNumber,
            onVerified: args.onVerified),
        settings: data,
      );
    },
    _i12.TermsView: (data) {
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.TermsView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class StartupViewArguments {
  const StartupViewArguments({this.key});

  final _i13.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant StartupViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LoginViewArguments {
  const LoginViewArguments({
    this.key,
    this.schema,
  });

  final _i13.Key? key;

  final _i14.LoginViewSchema? schema;

  @override
  String toString() {
    return '{"key": "$key", "schema": "$schema"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.schema == schema;
  }

  @override
  int get hashCode {
    return key.hashCode ^ schema.hashCode;
  }
}

class EnterCodeViewArguments {
  const EnterCodeViewArguments({
    this.key,
    required this.codeSentParams,
    required this.phoneNumber,
    required this.onVerified,
  });

  final _i13.Key? key;

  final _i15.CodeSentParams codeSentParams;

  final String phoneNumber;

  final dynamic Function() onVerified;

  @override
  String toString() {
    return '{"key": "$key", "codeSentParams": "$codeSentParams", "phoneNumber": "$phoneNumber", "onVerified": "$onVerified"}';
  }

  @override
  bool operator ==(covariant EnterCodeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.codeSentParams == codeSentParams &&
        other.phoneNumber == phoneNumber &&
        other.onVerified == onVerified;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        codeSentParams.hashCode ^
        phoneNumber.hashCode ^
        onVerified.hashCode;
  }
}

extension NavigatorStateExtension on _i16.NavigationService {
  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView({
    _i13.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.startupView,
        arguments: StartupViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView({
    _i13.Key? key,
    _i14.LoginViewSchema? schema,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key, schema: schema),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.registerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOnBoardingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.onBoardingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToComplexRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.complexRegisterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTryStaggeredAnimationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.tryStaggeredAnimationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTryStaggeredAnimationTwoView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.tryStaggeredAnimationTwoView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginWithSmsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginWithSmsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEnterCodeView({
    _i13.Key? key,
    required _i15.CodeSentParams codeSentParams,
    required String phoneNumber,
    required dynamic Function() onVerified,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.enterCodeView,
        arguments: EnterCodeViewArguments(
            key: key,
            codeSentParams: codeSentParams,
            phoneNumber: phoneNumber,
            onVerified: onVerified),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTermsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.termsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView({
    _i13.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.startupView,
        arguments: StartupViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView({
    _i13.Key? key,
    _i14.LoginViewSchema? schema,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key, schema: schema),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.registerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOnBoardingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.onBoardingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithComplexRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.complexRegisterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTryStaggeredAnimationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.tryStaggeredAnimationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTryStaggeredAnimationTwoView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.tryStaggeredAnimationTwoView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginWithSmsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginWithSmsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEnterCodeView({
    _i13.Key? key,
    required _i15.CodeSentParams codeSentParams,
    required String phoneNumber,
    required dynamic Function() onVerified,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.enterCodeView,
        arguments: EnterCodeViewArguments(
            key: key,
            codeSentParams: codeSentParams,
            phoneNumber: phoneNumber,
            onVerified: onVerified),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTermsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.termsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
