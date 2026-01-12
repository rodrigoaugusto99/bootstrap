const DEVELOPMENT = true; //appFlavor == 'internal' || kDebugMode;

const devApiUrl = '';
const prodApiUrl = '';

const apiUrl = DEVELOPMENT ? devApiUrl : prodApiUrl;

const WEAK_PASSWORD = 'Senha muito fraca. Por favor, use uma senha mais forte.';
const EMAIL_ALREADY_IN_USE = 'Já existe uma conta com esse email.';
const INVALID_CREDENTIAL = 'E-mail ou senha inválidos.';
const UNKNOW_ERROR = 'Erro desconhecido';
const INTERNAL_ERROR = 'Erro interno. Por favor, tente novamente mais tarde.';
