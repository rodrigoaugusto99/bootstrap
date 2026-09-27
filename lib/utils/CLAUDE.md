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
| `loading.dart` | 🔥 `showLoading`/`hideLoading`: o loading padrão das ações em que o usuário espera. A animação fica no `LoaderOverlay` do `main.dart` |
| `toast.dart` | Toasts |
| `popup.dart` | Popups |
| `svg_util.dart` | Widget `SvgUtil` |
| `image_util.dart` | Widget `ImageUtil` |
| `app_cached_network_image.dart` | 🔥 Toda imagem remota passa por aqui (placeholder, fallback e log de falha) |
| `url_launcher.dart` | `openUrl`, `openUrlWithFallback` |
| `firebase_storage.dart` | Wrapper Firebase Storage |
| `image_picker.dart` | Wrapper image_picker |
| `redirect_user.dart` | Lógica de redirecionamento pós-login |
| `custom_transition.dart` | `transitionAnimation()` — animação de slide para navegação |
| `get_context.dart` | `getContext()` — acessa `BuildContext` fora da árvore de widgets |
| `app_updater.dart` | 🔥 Atualização forçada: compara a versão instalada com o documento `app/infos` e manda para a loja |
| `logarte.dart` | Painel de logs em tela + interceptor Dio (apenas dev) |
| `gcp_logger.dart` | 🔥 `GCPLogger`: `LogOutput` que envia cada linha para o Cloud Logging (via `services/google_cloud_logging_service.dart`), só em release |
| `route_logger.dart` | 🔥 `RouteLogger`: `NavigatorObserver` que loga cada tela aberta, fechada ou trocada |
| `app_session.dart` | `AppSession`: id da sessão, versão e plataforma (vão nos logs e nos cabeçalhos `x-*` da API) |
| `utils.dart` | `sendWppMessage`, `removeSpecialCaracteres`, `unfocus`, `gerarCpfValido` |

## 🔥 Peças obrigatórias: nunca remover

Marcadas com 🔥 na tabela. Todo app criado a partir deste template as mantém **e ligadas**; remover uma é
decisão do Rodrigo, nunca do Claude.

| Peça | Ligada quer dizer |
|---|---|
| `loading.dart` | `LoaderOverlay` no `main.dart` com a animação do app; `showLoading`/`hideLoading` em toda ação em que o usuário espera (salvar, enviar, comprar, restaurar, gerar arquivo). Conteúdo da tela carregando usa esqueleto, quando o design tiver |
| `app_updater.dart` + `AppService` + `firestore/app.dart` | O `startup_viewmodel` chama `AppService.init()` e `userCanContinueUsingApp()`. Documento Firestore `app/infos` com `minVersionName`, `minBuildNumber` (texto), `androidStoreUrl`, `iosStoreUrl`; regra com leitura pública de `app/{doc}`. Sem o documento ou sem rede, o app segue |
| `gcp_logger.dart` + `services/google_cloud_logging_service.dart` | `GCPLogger` nos `loggerOutputs` do `app.dart`; `filter: ProductionFilter()` no `getLogger` do `app/app.logger.dart` (sem ele, release não loga nada; o `build_runner` apaga, ver [app/CLAUDE.md](../app/CLAUDE.md)); JSON da conta `<nome-interno>-logs` (papel único `roles/logging.logWriter`) colado no serviço; `logAppName` no `constants.dart` |
| `route_logger.dart` | `RouteLogger()` nos `navigatorObservers` do `main.dart` |
| `app_cached_network_image.dart` | Toda imagem remota passa por ele |

## Observabilidade

Qualquer problema que um usuário relatar tem que ser investigável pelos logs ou pelo banco, até a causa.

- Todo `catch` loga: `_log.e` (erro de verdade) ou `_log.w` (esperado, como falta de rede). Nada de
  `catch (_) {}` mudo.
- Toda ação relevante do usuário, toda leitura do Firestore (cache ou servidor) e toda chamada à API loga
  com `_log.i`, com os ids envolvidos.
- O `ApiService` manda `x-session-id`, `x-app-version` e `x-platform` em toda chamada; o backend
  (`request-logger.ts` do api_bootstrap) loga os três. É o que cruza o log do app com o do backend.
- Não logar: senha, token de autenticação, chave, dado de cartão.

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
