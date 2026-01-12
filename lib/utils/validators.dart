class Validators {
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve conter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value,
      {required String? confirmPassword}) {
    if (value == null || value.isEmpty) {
      return 'Insira sua nova senha';
    }
    if (value.length < 6) {
      return 'A senha deve conter pelo menos 6 caracteres';
    }
    if (value != confirmPassword) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira sua nova senha';
    }
    if (value.length < 6) {
      return 'A senha deve conter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? cpfOrEmail(
    String? value, {
    required bool isCpf,
  }) {
    if (isCpf) {
      final error = cpf(value);
      if (error == null) return null;
      return 'E-mail ou CPF inválidos';
    }

    final error = email(value);
    if (error == null) return null;
    return 'E-mail ou CPF inválidos';
  }

  static String? depositValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'O valor não pode estar vazio';
    }

    // Remove all non-numeric characters
    final cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Convert to integer and check if it's zero
    final intValue = int.tryParse(cleanedValue) ?? 0;

    if (intValue == 0) {
      return 'O valor não pode ser 0 reais';
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira um email';
    }

    // Regex para validar o formato do email
    RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegExp.hasMatch(value)) {
      return 'Email inválido';
    }

    return null; // Email válido
  }

  static String? cpfOrCnpj(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira um CPF ou CNPJ';
    }
    if (value.length != 14 && value.length != 18) {
      return 'Valor inválido';
    }
    if (value.length == 14) {
      return cpf(value);
    }
    if (value.length == 18) {
      return cnpj(value);
    }
    return null;
  }

  static String? cnpj(String? cnpj, {String? customMessage}) {
    if (cnpj == null || cnpj.isEmpty) {
      if (customMessage != null) {
        return customMessage;
      }
      return 'Insira seu CNPJ';
    }

    // Remove qualquer caractere que não seja número
    cnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se o CNPJ tem 14 dígitos ou se é uma sequência de números repetidos
    if (cnpj.length != 14 || RegExp(r'^(\d)\1*$').hasMatch(cnpj)) {
      return 'CNPJ inválido';
    }

    // Calcula o primeiro dígito verificador
    int sum = 0;
    List<int> weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    for (int i = 0; i < 12; i++) {
      sum += int.parse(cnpj[i]) * weights1[i];
    }
    int firstVerifier = sum % 11;
    firstVerifier = firstVerifier < 2 ? 0 : 11 - firstVerifier;

    // Calcula o segundo dígito verificador
    sum = 0;
    List<int> weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    for (int i = 0; i < 13; i++) {
      sum += int.parse(cnpj[i]) * weights2[i];
    }
    int secondVerifier = sum % 11;
    secondVerifier = secondVerifier < 2 ? 0 : 11 - secondVerifier;

    // Verifica se os dígitos verificadores são iguais aos informados
    if (firstVerifier == int.parse(cnpj[12]) &&
        secondVerifier == int.parse(cnpj[13])) {
      return null;
    }
    return 'CNPJ inválido';
  }

  static String? cpf(String? cpf, {String? customMessage}) {
    if (cpf == null || cpf.isEmpty) {
      if (customMessage != null) {
        return customMessage;
      }
      return 'Insira seu CPF';
    }
    // Remove qualquer caractere que não seja número
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se o CPF tem 11 dígitos ou se é uma sequência de números repetidos
    if (cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    // Calcula o primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int firstVerifier = sum % 11;
    firstVerifier = firstVerifier < 2 ? 0 : 11 - firstVerifier;

    // Calcula o segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int secondVerifier = sum % 11;
    secondVerifier = secondVerifier < 2 ? 0 : 11 - secondVerifier;

    // Verifica se os dígitos verificadores são iguais aos informados
    if (firstVerifier == int.parse(cpf[9]) &&
        secondVerifier == int.parse(cpf[10])) {
      return null;
    }
    return 'CPF inválido';
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve conter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira uma data';
    }

    // Tenta fazer parsing da data no formato dd/MM/yyyy
    try {
      // Converte a string para DateTime
      List<String> parts = value.split('/');
      if (parts.length != 3) {
        return 'Data inválida';
      }

      int? day = int.tryParse(parts[0]);
      int? month = int.tryParse(parts[1]);
      int? year = int.tryParse(parts[2]);

      if (day == null || month == null || year == null) {
        return 'Data inválida';
      }

      DateTime? parsedDate;
      try {
        parsedDate = DateTime(year, month, day);
        // Verifica se a data realmente existe (evita 32/01/2020 virar 01/02/2020)
        if (parsedDate.day != day ||
            parsedDate.month != month ||
            parsedDate.year != year) {
          return 'Data inválida';
        }
      } catch (e) {
        return 'Data inválida';
      }

      if (parsedDate.isAfter(DateTime.now())) {
        return 'A data não pode ser no futuro';
      }

      return null; // Data válida
    } catch (e) {
      return 'Data inválida';
    }
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira um número de celular';
    }

    // Remove caracteres não numéricos
    value = value.replaceAll(RegExp(r'\D'), '');

    // Verifica se o número tem exatamente 11 dígitos
    if (value.length != 11) {
      return 'O número de celular deve ter 11 dígitos';
    }

    // Regex para validar o DDD de acordo com as regras fornecidas
    RegExp dddRegExp =
        RegExp(r'^((1|4|6|8|9)\d)|(2[12478])|(3[1-57-8])|(5[13-5])|(7[1-79])$');
    String ddd = value.substring(0, 2);

    if (!dddRegExp.hasMatch(ddd)) {
      return 'DDD inválido';
    }

    // Verifica se o número de celular começa com 9
    String phoneNumber = value.substring(2);
    if (!phoneNumber.startsWith('9')) {
      return 'O número de celular deve começar com 9';
    }

    // Verifica se o número de celular segue o formato esperado
    RegExp phoneRegExp = RegExp(r'^9\d{8}$');
    if (!phoneRegExp.hasMatch(phoneNumber)) {
      return 'Número de celular inválido';
    }

    // Verifica se o número de celular não é composto de dígitos repetidos
    // if (RegExp(r'^9(\d)\1{7}$').hasMatch(phoneNumber)) {
    //   return 'Número de celular inválido (todos os dígitos são iguais)';
    // }

    return null; // Se todas as verificações passarem, o número é válido
  }

  static String? value(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira seu valor';
    }
    final isNumeric = RegExp(r'^\d+$');
    if (!isNumeric.hasMatch(value)) {
      return 'O valor deve conter apenas números';
    }
    return null;
  }

  static String? fullName(String? value,
      {String customMessage = 'Insira seu nome completo'}) {
    if (value == null || value.isEmpty) {
      return customMessage;
    }

    // Verifica se contém apenas letras e espaços
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value)) {
      return 'O nome deve conter apenas letras e espaços';
    }

    // Verifica se há pelo menos dois nomes separados por espaço
    if (value.split(' ').length < 2) {
      return customMessage;
    }

    return null;
  }

  static String? parentName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira um nome';
    }

    // Divide o valor em palavras
    final words = value.trim().split(RegExp(r'\s+'));

    // Verifica se há pelo menos duas palavras e se cada uma tem pelo menos 2 letras
    if (words.any((word) => word.length < 2)) {
      return 'Nome inválido';
    }

    if (words.length < 2) {
      return 'Insira o nome completo';
    }

    // Permite letras, espaços e caracteres com acento
    final hasInvalidCharacters = value.contains(RegExp(r'[^a-zA-ZÀ-ÿ\s]'));
    if (hasInvalidCharacters) {
      return 'É permitido apenas letras e espaços';
    }

    return null; // Nome válido
  }

  static String? rg(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira seu RG';
    }

    // Remove todos os caracteres não numéricos (exceto X/x para dígito verificador)
    final cleanedValue = value.replaceAll(RegExp(r'[^\dXx]'), '');

    // Verifica o tamanho mínimo e máximo (normalmente entre 7 e 10 dígitos)
    if (cleanedValue.length < 7 || cleanedValue.length > 10) {
      return 'RG inválido';
    }

    // Verifica se contém apenas números e X/x (para dígito verificador)
    if (!RegExp(r'^[\dXx]+$').hasMatch(cleanedValue)) {
      return 'RG contém caracteres inválidos';
    }

    return null; // RG válido
  }

  static String? generic(String? value,
      {String emptyErrorMessage = 'Este campo é obrigatório'}) {
    if (value == null || value.isEmpty) {
      return emptyErrorMessage;
    }

    return null; // Número válido
  }

  static String? name(String? value, {String? emptyString}) {
    if (value == null || value.isEmpty) {
      if (emptyString != null) {
        return emptyString;
      }
      return 'Insira seu nome';
    }
    if (value.length < 3) {
      return 'Nome inválido, insira mais de 3 caracteres';
    }
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value)) {
      return 'Nome inválido, não use números ou caracteres especiais';
    }
    return null;
  }

  static String? projectName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira o nome do projeto';
    }
    if (value.length < 3) {
      return 'Nome inválido, insira mais de 3 caracteres';
    }
    return null;
  }

  static String? cep(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira seu CEP';
    }
    if (value.length < 8) {
      return 'CEP inválido';
    }
    return null;
  }

  static String? birthDate(String? text) {
    if (text == null || text.isEmpty) {
      return 'Insira sua data de nascimento';
    }
    if (text.length < 10) {
      return 'Data inválida';
    }
    var date = text.split('/');
    if (date.length != 3) {
      return 'Data inválida';
    }
    var day = int.tryParse(date[0]);
    var month = int.tryParse(date[1]);
    var year = int.tryParse(date[2]);
    if (day == null || month == null || year == null) {
      return 'Data inválida';
    }
    if (day < 1 || day > 31) {
      return 'Dia inválido';
    }
    if (month < 1 || month > 12) {
      return 'Mês inválido';
    }
    if (year < 1900 || year > DateTime.now().year) {
      return 'Ano inválido';
    }
    return null;
  }

  static String? streetValidator(String? value) {
    if (value == null || value.isEmpty) return "Insira o nome da rua";
    if (value.length < 3) return "Rua inválida";
    return null;
  }

  static String? numberValidator(String? value) {
    if (value == null || value.isEmpty) return "Insira o número";
    if (value.isEmpty) return "Número inválido";
    return null;
  }

  static String? complementoValidator(String? value) {
    if (value != null && value.isNotEmpty && value.length > 50) {
      return 'Limite de 50 caracteres';
    }

    return null;
  }

  static String? neighborhoodValidator(String? value) {
    if (value == null || value.isEmpty) return "Insira o bairro";
    if (value.length < 3) return "Bairro inválido";
    return null;
  }

  static List<String> validUFs = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  static String? stateValidator(String? value) {
    if (value == null || value.isEmpty) return "Insira o estado";
    if (value.length != 2) return "Estado inválido";
    if (!validUFs.contains(value)) return "Estado inválido";

    return null;
  }

  static String? cityValidator(String? value) {
    if (value == null || value.isEmpty) return "Insira a cidade";
    if (value.length < 3) return "Cidade inválida";

    return null;
  }

  static String? agencyValidator(String? value) {
    if (value == null || value.isEmpty) return "Insira a agência";
    if (value.length != 4) return "Agência inválida";

    return null;
  }

  static String? accountValidator(String? value) {
    if (value == null || value.isEmpty) return "Insira a conta";
    if (value.length != 6) return "Conta inválida";

    return null;
  }

  static String? customEmptyMessage(String? value, {required String message}) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }

  static String? smsCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira o código';
    }

    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedValue.length != 6) {
      return 'O código deve ter 6 dígitos';
    }

    return null;
  }
}
