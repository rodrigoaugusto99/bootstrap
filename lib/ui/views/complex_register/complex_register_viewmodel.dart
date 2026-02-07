import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/models/user_model.dart';
import 'package:bootstrap/schemas/user_registration_schema.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/services/user_service.dart';
import 'package:bootstrap/utils/enums.dart';
import 'package:bootstrap/utils/loading.dart';
import 'package:bootstrap/utils/redirect_user.dart';
import 'package:bootstrap/utils/toast.dart';
import 'package:bootstrap/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ComplexRegisterViewModel extends BaseViewModel {
  int? initialPage;

  ComplexRegisterViewModel({
    this.initialPage,
  }) {
    _init();
  }

  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _log = getLogger('ComplexRegisterViewModel');

  int currentPage = 0;
  int totalPages = 2;

  bool get isLastPage => currentPage == totalPages - 1;
  bool get isFirstPage => currentPage == 0;
  bool get canLogout => !isFirstPage;
  UserModel? get user => _userService.user.value;
  String get buttonText => isLastPage ? 'Continuar' : 'Finalizar cadastro';

  PageController pageController = PageController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController celularController = TextEditingController();

  TextEditingController enderecoCompletoController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController pontoReferenciaController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController cidadeSelecionadaController = TextEditingController();
  TextEditingController estadoSelecionadoController = TextEditingController();

  bool enableStreet = true;
  bool enableNeighborhood = true;
  bool enableState = true;
  bool enableCity = true;

  SexEnum sexSelected = SexEnum.male;
  List<FruitEnum> fruitsSelected = [];

  final firstFormKey = GlobalKey<FormState>();
  final secondFormKey = GlobalKey<FormState>();

  void _init() {
    pageController.addListener(_onPageControllerChanged);
    // _retrieveLostImage();
  }

  /* VALIDATIONS */

  Future<bool> _checkIfFormIsValid() async {
    if (currentPage == 1) {
      if (true) {
        AppToast.showToast(
          text: 'Selecione a isso',
        );
        return false;
      }
    }

    return true;
  }

  bool get _validateForm {
    switch (currentPage) {
      case 0:
        return firstFormKey.currentState!.validate();
      case 1:
        return secondFormKey.currentState!.validate();
      default:
        return false;
    }
  }

  void _advanceToNextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageControllerChanged() {
    final page = pageController.page?.round() ?? 0;
    if (page != currentPage) {
      currentPage = page;
      notifyListeners();
    }
  }

  void handleSelectState(String state) {
    estadoSelecionadoController.text = state;
    notifyListeners();
  }

  void handleToggleSex(SexEnum sex) {
    sexSelected = sex;
    notifyListeners();
  }

  void handleSelectFruit(
    FruitEnum fruit,
  ) {
    if (fruitsSelected.contains(fruit)) {
      fruitsSelected.remove(fruit);
    } else {
      fruitsSelected.add(fruit);
    }
    notifyListeners();
  }

  void handleBack() {
    if (isFirstPage) {
      _navigationService.back();
      return;
    }
    _previousPage();
  }

  Future<void> handleNextPage() async {
    if (!_validateForm) return;

    bool formIsValid = await _checkIfFormIsValid();
    if (!formIsValid) return;

    unfocus();

    if (isLastPage) {
      _finalize();
      return;
    }

    _advanceToNextPage();
  }

  // Future<void> _retrieveLostImage() async {
  //   try {
  //     final file = await image_picker_util.retrieveLostImage();
  //     if (file != null) {
  //       profileImage = file;
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     _log.e(e);
  //   }
  // }

  Future<void> onCepChanged() async {
    // if (cepController.text.length != 9) {
    //   return;
    // }
    // final viaCepSearchCep = ViaCepSearchCep();
    // showLoading();
    // final infoCepJSON = await viaCepSearchCep.searchInfoByCep(
    //     cep: cepController.text.replaceAll('-', ''));
    // infoCepJSON.fold(
    //   (error) {
    //     hideLoading();
    //     _log.w('Erro ao buscar informações do CEP: $error');
    //     notifyListeners();
    //   },
    //   (infoCepJSON) {
    //     hideLoading();
    //     enderecoCompletoController.text = infoCepJSON.logradouro ?? '';
    //     bairroController.text = infoCepJSON.bairro ?? '';
    //     estadoSelecionadoController.text = infoCepJSON.uf?.toUpperCase() ?? '';
    //     cidadeSelecionadaController.text = infoCepJSON.localidade ?? '';

    //     enableStreet = enderecoCompletoController.text.isEmpty;
    //     enableNeighborhood = bairroController.text.isEmpty;
    //     enableState = estadoSelecionadoController.text.isEmpty;
    //     enableCity = cidadeSelecionadaController.text.isEmpty;
    //     notifyListeners();
    //   },
    // );
  }

  Future<void> _finalize() async {
    _log.i('Finalizing registration');

    try {
      showLoading();
      // IMAGEM

      //String? imageUrl;

      // if (profileImage != null) {
      //   imageUrl = await uploadFile(
      //     file: profileImage!,
      //     fileName: 'avatar',
      //     userId: _authService.currUser!.uid,
      //   );
      // }

      // ENDEREÇO:
      // final address = AddressModel(
      //   postalCode: cepController.text.trim(),
      //   street: enderecoCompletoController.text.trim(),
      //   neighborhood: bairroController.text.trim(),
      //   city: estadoSelecionadoController.text.trim(),
      //   state: estadoSelecionadoController.text.trim(),
      // );

      // final response =
      //     await _locationService.getCoordinatesFromAddress(address);

      // address.latitude = response.latitude;
      // address.longitude = response.longitude;

      final userRegistrationSchema = UserRegistrationSchema(
        name: fullNameController.text,
      );

      await _userService.updateUserRegistration(userRegistrationSchema);
      _log.i('User created successfully');

      // ANALYTICS:
      // _analyticsService.logSignUp(
      //   method: 'phone',
      // );

      await RedirectUser().redirectUser();
    } catch (e) {
      hideLoading();
      _log.e('Error finalizing registration: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    pageController.removeListener(_onPageControllerChanged);
    fullNameController.dispose();
    celularController.dispose();
    enderecoCompletoController.dispose();
    bairroController.dispose();
    pontoReferenciaController.dispose();
    super.dispose();
  }
}
