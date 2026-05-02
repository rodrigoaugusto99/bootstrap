# daily_words

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
├── services/                   ← ver lib/services/CLAUDE.md
├── utils/                      ← ver lib/utils/CLAUDE.md
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

Ver [lib/CLAUDE.md](lib/CLAUDE.md) para fluxo de dados, arquitetura de diretórios e regras por camada.

## Regras Gerais

- Nomes de funções e classes em inglês.
- Não faça comentários no código.
- Não crie arquivos `.svg` — os arquivos de imagem sempre estarão criados antes.
- Nunca use `print()`. Use o logger. → [.claude/examples/ex_logger.dart](.claude/examples/ex_logger.dart)
