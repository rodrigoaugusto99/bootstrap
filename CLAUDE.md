# Bootstrap

Template Flutter com Stacked + Firebase. Base para novos projetos.

## Stack

- Flutter stable (FVM)
- Stacked `^3.4.0` + `stacked_services`
- Firebase: Auth, Firestore, Storage, Messaging
- Dio para HTTP

## Comandos

```bash
# Rodar o app
flutter run

# Gerar código (após criar/alterar views, dialogs, bottom sheets, locator)
dart run build_runner build --delete-conflicting-outputs
```

> Os arquivos gerados ficam em `lib/app/` — nunca edite manualmente.

## Estrutura

```
lib/
├── app/                        ← gerado, nunca mexa
├── exceptions/app_error.dart   ← AppError
├── firestore/                  ← user, notification, subscription, app
├── models/                     ← UserModel, AddressModel, NotificationModel, SubscriptionModel
├── schemas/                    ← AuthenticateAnonymousSchema, CodeSentSchema, LoginViewSchema,
│                                  UserRegistrationSchema, VerifyCodeSchema,
│                                  GetCoordinatesFromAddressResponse
├── services/                   ← ver lista abaixo
├── utils/                      ← ver lista abaixo
├── ui/
│   ├── common/                 ← app_colors, app_theme, app_strings
│   ├── components/             ← AppButton, CustomAppBar, CustomTextFormField, Loading,
│   │                              PinCodeField, CustomCheckBox, CustomRadioBall,
│   │                              CustomBottomNavigationBar
│   ├── dialogs/info_alert/
│   ├── bottom_sheets/notice/
│   └── views/
│       ├── startup/            ← splash + redirecionamento
│       ├── on_boarding/
│       ├── login/
│       ├── register/
│       ├── complex_register/   ← multi-step com pages/
│       └── home/
├── firebase_options.dart
└── main.dart
```

## Services

| Service | Responsabilidade |
|---------|-----------------|
| `UserService` | Usuário logado (instância + ValueNotifier) |
| `AuthService` | Firebase Auth: email, Google, Apple, anônimo |
| `AppService` | Estado global do app |
| `NotificationService` | FCM + notificações locais |
| `LocationService` | Geolocator + geocoding |
| `ApiService` | HTTP via Dio |
| `SubscriptionService` | Controle de assinaturas |
| `AlarmService` | Alarmes locais |
| `AnalyticsService` | Analytics |
| `ConectivityService` | Monitoramento de rede |

## Utils relevantes

| Arquivo | O que faz |
|---------|-----------|
| `validators.dart` | Validadores estáticos para `TextFormField` |
| `easy_mask.dart` | Máscaras de input |
| `shared_preferences.dart` | Wrapper de SharedPreferences (use enums para keys) |
| `svg_util.dart` | Widget `SvgUtil` |
| `image_util.dart` | Widget `ImageUtil` |
| `enums.dart` | Enums globais |
| `redirect_user.dart` | Lógica de redirecionamento pós-login |
| `loading.dart` | Controle do overlay de loading |
| `toast.dart` | Toasts |
| `popup.dart` | Popups |
| `firebase_storage.dart` | Wrapper Firebase Storage |
| `image_picker.dart` | Wrapper image_picker |

## Assets

- `assets/images/` — imagens (declaradas em `pubspec.yaml`)
- `assets/icons/` — SVGs (se houver)
- `assets/fonts/` — fontes (configurar em `pubspec.yaml` se necessário)
