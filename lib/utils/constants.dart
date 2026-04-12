const DEVELOPMENT = true; //appFlavor == 'internal' || kDebugMode;
const useEmulator = bool.fromEnvironment('USE_EMULATOR');
const host = '192.168.15.82'; //'10.0.2.2';
const emulatorUrl =
    'http://$host:5001/fidelizei-cartoes/southamerica-east1/api';

const devApiUrl = '';
const prodApiUrl = '';

const androidStoreUrl = '';
const iosStoreUrl = '';

const apiUrl = DEVELOPMENT ? devApiUrl : prodApiUrl;

const WEAK_PASSWORD = 'Senha muito fraca. Por favor, use uma senha mais forte.';
const EMAIL_ALREADY_IN_USE = 'Já existe uma conta com esse email.';
const INVALID_CREDENTIAL = 'E-mail ou senha inválidos.';
const UNKNOW_ERROR = 'Erro desconhecido';
const INTERNAL_ERROR = 'Erro interno. Por favor, tente novamente mais tarde.';
