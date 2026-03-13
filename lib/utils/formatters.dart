import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// 100 → "R$1,00" | 150000 → "R$1.500,00"
// hasSimbol: false → "1,00"
String formatValue(int value, {bool hasSimbol = true}) {
  return CurrencyTextInputFormatter.currency(
    locale: 'pt-BR',
    symbol: !hasSimbol ? '' : 'R\$',
  ).formatDouble(value / 100);
}

// TextInputFormatter para campos de moeda: digita 150000 → exibe "R$1.500,00"
TextInputFormatter currencyFormatter = CurrencyTextInputFormatter.currency(
  locale: 'pt-BR',
  symbol: 'R\$',
);

final phoneMaskFormatter =
    TextInputMask(mask: ['(99) 99999-9999'], reverse: false);

final dateMaskFormatter = TextInputMask(mask: ['99/99/9999'], reverse: false);

final cpfMaskFormatter =
    TextInputMask(mask: ['999.999.999-99'], reverse: false);

final cnpjMaskFormatter =
    TextInputMask(mask: ['99.999.999/9999-99'], reverse: false);

final rgMaskFormatter = TextInputMask(mask: ['99.999.999-9'], reverse: false);

final cepMaskFormatter = TextInputMask(mask: ['99999-999'], reverse: false);

// 1234.56 → "R$1.234,56"
String formatValueDouble(double value) {
  return CurrencyTextInputFormatter.currency(
    locale: 'pt-BR',
    symbol: 'R\$',
  ).formatDouble(value);
}

// "1234,56" → "R$ 1234,56"
String formatCurrency(String value) => 'R\$ $value';

// "R$ 1.234,56" → "1234,56"
String cleanCurrency(String input) {
  return input.replaceAll(RegExp(r'[\sR$]'), '');
}

// "R$ 2.400,00" → "2400.00"  |  "R$ 50,00" → "50.00"
String converterParaNumerico(String valorMonetario) {
  String valor = valorMonetario.replaceAll('R\$', '').trim();
  valor = valor.replaceAll('.', '');
  valor = valor.replaceAll(',', '.');
  return valor;
}

// "12,34" → "1234"  |  "1.234,56" → removido não-numérico → "1234.56"
String removeNonNumericCharacters(String input) {
  String filtered = input.replaceAll(RegExp(r'[^\d,]'), '');
  filtered = filtered.replaceAll(',', '.');
  return filtered;
}

// 2525.25 → 252525  |  2525.20 → 252520
int getDoubleValueInCentavos(double value) {
  final stringValue = value.toStringAsFixed(2);
  final newValue = stringValue.replaceAll('.', '');
  return int.parse(newValue);
}

// 0.15 → "15%"  |  0.075 → "7,5%"  |  1.0 → "100%"
String formatPercentage(double value) {
  final formatter = NumberFormat('#,##0.00', 'pt_BR');
  String formatted = formatter.format(value);
  if (formatted.contains(',')) {
    formatted = formatted.replaceAll(RegExp(r',?0+$'), '');
  }
  return '$formatted%';
}

// "21970323990" → "(21) 97032-3990"  |  "1133334444" → "(11) 3333-4444"
String formatPhoneNumber(String phoneNumber) {
  String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  if (cleanNumber.length != 10 && cleanNumber.length != 11) {
    return phoneNumber;
  }
  if (cleanNumber.length == 11) {
    return '(${cleanNumber.substring(0, 2)}) ${cleanNumber.substring(2, 7)}-${cleanNumber.substring(7)}';
  }
  return '(${cleanNumber.substring(0, 2)}) ${cleanNumber.substring(2, 6)}-${cleanNumber.substring(6)}';
}

// DateTime(2026, 3, 12) → "Quinta, 12/03/2026"
String formatDate(DateTime date) {
  return DateFormat('EEEE, dd/MM/yyyy', 'pt_BR').format(date);
}

// DateTime(2026, 3, 12) → "12/03/2026"
String formatDate2(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

// DateTime(2026, 3, 12) → "12 de março de 2026"
String formatDate3(DateTime date) {
  return DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(date);
}

// DateTime(2026, 3, 12) → "12/03"
String formatDate4(DateTime date) {
  return DateFormat('dd/MM').format(date);
}

// DateTime(2026, 3, 12, 14, 30) → "12/03 às 14:30"
String formatDate5(DateTime date) {
  return DateFormat('dd/MM \'às\' HH:mm').format(date);
}

// DateTime(2026, 3, 12, 14, 30) → "12/03/2026 às 14:30"
String formatDate6(DateTime date) {
  return DateFormat('dd/MM/yyyy \'às\' HH:mm').format(date);
}

// "2026-03-12T00:00:00.000Z" → "12/03/2026"
String formatISOToBrDate(String isoString) {
  final dateTime = DateTime.parse(isoString);
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

// null → "—"  |  "2026-03-12T00:00:00.000Z" → "12/03/2026"
String formatNullableDate(String? dateStr) {
  if (dateStr == null) return '—';
  try {
    return formatISOToBrDate(dateStr);
  } catch (_) {
    return dateStr;
  }
}

// "12/03/2026" → DateTime(2026, 3, 12)
DateTime parseDateString(String dateStr) {
  final parts = dateStr.split('/');
  return DateTime(
    int.parse(parts[2]),
    int.parse(parts[1]),
    int.parse(parts[0]),
  );
}

// "12/03/2026" → "2026-03-12T00:00:00.000"
String formatDateToISO(String dateStr) {
  return parseDateString(dateStr).toIso8601String();
}

// DateTime(2026, 3, 12, 14, 30) → "14:30"
String formatTime(DateTime dateTime) {
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}

// "14:30" + DateTime(2026, 3, 12) → DateTime(2026, 3, 12, 14, 30)
DateTime timeFromString(String time, DateTime baseDate) {
  final parts = time.split(':');
  return DateTime(
    baseDate.year,
    baseDate.month,
    baseDate.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}

// 1500.0 → "1,5 km"  |  7000.0 → "7 km"
String metersToKm(double meters) {
  double km = meters / 1000;
  if (km % 1 == 0) {
    return '${km.toInt()} km';
  }
  return '${km.toStringAsFixed(1)} km';
}
