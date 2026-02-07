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

//todo: averiguar esse erro
/*
Error getting address: PlatformException(IO_ERROR, java.util.concurrent.TimeoutException: Waited 5 seconds 
(plus 379373 nanoseconds delay) for kii@801c5da[status=PENDING, info=[tag=[ReverseGeocode]]], null, null)
 */
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
