# Utils

Wrappers de pacotes externos e helpers globais. Não contêm lógica de negócio.

## Arquivos e responsabilidades

| Arquivo | O que faz |
|---------|-----------|
| `enums.dart` | Enums globais do app — adicione aqui enums usados em Models ou em múltiplos lugares |
| `constants.dart` | URLs da API, URLs das stores, flag `DEVELOPMENT`, mensagens de erro globais |
| `validators.dart` | Validadores estáticos para `TextFormField` |
| `formatters.dart` | Formatação de datas, moeda, telefone, máscaras de input |
| `helpers.dart` | `decContainer`, `styledText`, `heightSeparator`, `widthSeparator`, layout responsivo |
| `shared_preferences.dart` | Wrapper de SharedPreferences — sempre use enums para keys |
| `loading.dart` | Controle do overlay de loading |
| `toast.dart` | Toasts |
| `popup.dart` | Popups |
| `svg_util.dart` | Widget `SvgUtil` |
| `image_util.dart` | Widget `ImageUtil` |
| `app_cached_network_image.dart` | Imagem remota com skeleton e fallback de erro |
| `url_launcher.dart` | `openUrl`, `openUrlWithFallback` |
| `firebase_storage.dart` | Wrapper Firebase Storage |
| `image_picker.dart` | Wrapper image_picker |
| `redirect_user.dart` | Lógica de redirecionamento pós-login |
| `custom_transition.dart` | `transitionAnimation()` — animação de slide para navegação |
| `get_context.dart` | `getContext()` — acessa `BuildContext` fora da árvore de widgets |
| `app_updater.dart` | Verificação de versão mínima e redirecionamento para a store |
| `logarte.dart` | Painel de logs em tela + interceptor Dio (apenas dev) |
| `GCPLogger.dart` | `LogOutput` que envia logs para o Google Cloud Logging |
| `utils.dart` | `sendWppMessage`, `removeSpecialCaracteres`, `unfocus`, `gerarCpfValido` |

## Logger

Use `getLogger` de `app/app.logger.dart` — nunca `print()`.

```dart
final _log = getLogger('NomeDaClasse');

_log.i('mensagem informativa');
_log.w('aviso');
_log.e('erro');
```

→ [examples/ex_logger.dart](../../.claude/examples/ex_logger.dart)

## SharedPreferences

Sempre use enums para keys — nunca strings soltas.

```dart
enum SharedPreferencesKeys { sawOnboarding, isDarkMode }

bool sawOnboarding = await getBoolSharedPreferences(SharedPreferencesKeys.sawOnboarding);
await setBoolSharedPreferences(key: SharedPreferencesKeys.sawOnboarding, value: true);
```

→ [.claude/shared_preferences/references/ex_shared_preferences.dart](../../.claude/shared_preferences/references/ex_shared_preferences.dart)
