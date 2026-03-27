import 'dart:async';
import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/schemas/get_coordinates_from_address_response.dart';
import 'package:bootstrap/services/api_service.dart';
import 'package:bootstrap/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/exceptions/app_error.dart';
import 'package:bootstrap/models/address_model.dart';

class AddressByCep {
  final String? logradouro;
  final String? bairro;
  final String? uf;
  final String? localidade;
  AddressByCep({
    required this.logradouro,
    required this.bairro,
    required this.uf,
    required this.localidade,
  });
}

class LocationService {
  final _log = getLogger("LocationService");
  ValueNotifier<Position?> currentLocation = ValueNotifier(null);

  final _apiService = locator<ApiService>();

  Future<GetCoordinatesFromAddressResponse> getCoordinatesFromAddress(
    AddressModel address,
  ) async {
    final response = await _apiService.request(
      method: HttpMethod.POST,
      url: '$apiUrl/user/geocoding',
      body: address.toMap(),
    );

    return GetCoordinatesFromAddressResponse(
      latitude: response['latitude'],
      longitude: response['longitude'],
    );
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de localização está ativado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
//_log.i('serviceEnabled: $serviceEnabled');
    if (!serviceEnabled) {
      // Se o serviço não estiver ativado, tente solicitar ao usuário para ativar
      bool locationEnabled = await Geolocator.openLocationSettings();
      // //_log.i('locationEnabled: $locationEnabled');
      if (!locationEnabled) {
        throw AppError(message: 'Serviço de localização desativado');
      }
    }

    // Verifica as permissões
    permission = await Geolocator.checkPermission();
    //_log.i('permission: $permission');
    if (permission == LocationPermission.denied) {
      // Se a permissão foi negada, solicite novamente
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Se o usuário negou novamente, lance uma exceção
        throw AppError(message: 'Permissão de localização negada pelo usuário');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _log.e(
          'Permissão negada permanentemente. Por favor, habilite nas configurações.');
      // Se o usuário negou permanentemente, abra as configurações do app
      // bool opened = await openAppSettings();
      // if (!opened) {
      //   throw Exception(
      //       'Permissão negada permanentemente. Por favor, habilite nas configurações.');
      // }
      // // Após abrir as configurações, verifique novamente
      // return getCurrentLocation();
    }

    // Se chegou aqui, temos permissão, então obtenha a posição
    return await Geolocator.getCurrentPosition();
  }

  Future<AddressModel?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      //  //_log.i('Placemarks: $placemarks');

      String city = placemarks[0].subAdministrativeArea.toString();
      return AddressModel(
        street: placemarks[0].street.toString(),
        number: placemarks[0].subThoroughfare.toString(),
        neighborhood: placemarks[0].subLocality.toString(),
        city: city.isNotEmpty ? city : placemarks[0].locality.toString(),
        postalCode: placemarks[0].postalCode.toString(),
        state: obterUF(placemarks[0].administrativeArea!)!,
      );
    } catch (e) {
      _log.e("Error getting address: $e");
      return null;
      // throw Exception("Error getting address: $e");
    }
  }

  Future<AddressByCep?> fetchCepFromBrasilApi(String cep) async {
    try {
      _log.i('buscando cep via BrasilAPI');

      final data = await locator<ApiService>()
          .request(
            url: 'https://brasilapi.com.br/api/cep/v1/$cep',
            method: HttpMethod.GET,
          )
          .timeout(const Duration(seconds: 10));
      return AddressByCep(
        logradouro: data['street'] as String?,
        bairro: data['neighborhood'] as String?,
        uf: data['state'] as String?,
        localidade: data['city'] as String?,
      );
    } on Exception catch (e) {
      _log.w('Erro ao buscar CEP via BrasilAPI: $e');
    }
    return null;
  }

  Future<AddressByCep?> getAddressFromCep(String rawCep) async {
    final cep = rawCep.replaceAll('-', '');
    try {
      _log.i('buscando cep via ViaCEP');
      final data = await _apiService
          .request(
            url: 'https://viacep.com.br/ws/$cep/json/',
            method: HttpMethod.GET,
          )
          .timeout(const Duration(seconds: 10));
      return AddressByCep(
        logradouro: data['logradouro'] as String?,
        bairro: data['bairro'] as String?,
        uf: data['uf'] as String?,
        localidade: data['localidade'] as String?,
      );
    } on Exception catch (e) {
      _log.w('Erro ao buscar CEP via ViaCEP: $e');
    }
    return await fetchCepFromBrasilApi(cep);
  }
}

Map<String, String> estadosParaUF = {
  'Acre': 'AC',
  'Alagoas': 'AL',
  'Amapá': 'AP',
  'Amazonas': 'AM',
  'Bahia': 'BA',
  'Ceará': 'CE',
  'Distrito Federal': 'DF',
  'Espírito Santo': 'ES',
  'Goiás': 'GO',
  'Maranhão': 'MA',
  'Mato Grosso': 'MT',
  'Mato Grosso do Sul': 'MS',
  'Minas Gerais': 'MG',
  'Pará': 'PA',
  'Paraíba': 'PB',
  'Paraná': 'PR',
  'Pernambuco': 'PE',
  'Piauí': 'PI',
  'Rio de Janeiro': 'RJ',
  'Rio Grande do Norte': 'RN',
  'Rio Grande do Sul': 'RS',
  'Rondônia': 'RO',
  'Roraima': 'RR',
  'Santa Catarina': 'SC',
  'São Paulo': 'SP',
  'Sergipe': 'SE',
  'Tocantins': 'TO',
};

String? obterUF(String estado) {
  return estadosParaUF[estado] ?? 'DF';
}
