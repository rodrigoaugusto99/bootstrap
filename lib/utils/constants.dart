const _usePhysicalDevice = bool.fromEnvironment('USE_PHYSICAL_DEVICE');
const _projectId = 'daily-words-5a5ad';
const _emulatorUrl = 'http://$host:5002/$_projectId/southamerica-east1/api';
const _devApiUrl = '';
const _prodApiUrl = '';

const DEVELOPMENT = true; //appFlavor == 'internal' || kDebugMode;

// Label app_name dos logs do app no Cloud Logging: trocar pelo <nome-interno> do app.
const logAppName = 'bootstrap';

// Atualização forçada: usadas quando o app/infos não traz os links das lojas.
const androidStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.bootstrap';
const iosStoreUrl = 'https://apps.apple.com/app/id0000000000';
const useFirebaseEmulator = bool.fromEnvironment('USE_FIREBASE_EMULATOR');
const host = _usePhysicalDevice ? '192.168.15.82' : '10.0.2.2';

const apiUrl = useFirebaseEmulator
    ? _emulatorUrl
    : DEVELOPMENT
        ? _devApiUrl
        : _prodApiUrl;

const WEAK_PASSWORD = 'Senha muito fraca. Por favor, use uma senha mais forte.';
const EMAIL_ALREADY_IN_USE = 'Já existe uma conta com esse email.';
const INVALID_CREDENTIAL = 'E-mail ou senha inválidos.';
const UNKNOW_ERROR = 'Erro desconhecido';
const INTERNAL_ERROR = 'Erro interno. Por favor, tente novamente mais tarde.';
