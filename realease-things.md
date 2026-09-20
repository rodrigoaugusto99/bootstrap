# notificações

## link pra gerar as imagens pro drawable
https://romannurik.github.io/AndroidAssetStudio/icons-notification

## android manifest:

<meta-data
                android:name="com.google.firebase.messaging.default_notification_channel_id"
                android:value="high_importance_channel"/>
        <meta-data
                android:name="com.google.firebase.messaging.default_notification_icon"
                android:resource="@drawable/ic_notification"/>

## flutter_local_notifications

pode usar mipmap 

```dart
Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
```


-----------------------------------------------------------

# icones

## Caminho padrão: flutter_launcher_icons (já está no projeto)

Um PNG **1024×1024 sem canal alfa** em `assets/icon/icon.png` e um comando geram
os ícones das duas plataformas:

```bash
dart run flutter_launcher_icons
```

A config está no `pubspec.yaml`. O `remove_alpha_ios: true` resolve sozinho a
**rejeição da Apple por canal alfa** — que é a armadilha desta etapa.
Detalhes da arte: [assets/icon/README.md](assets/icon/README.md).

## Caminho manual: icon.kitchen

Vale quando a logo precisa de ajuste fino de margem dentro do ícone adaptativo
do Android, que é visual e difícil de acertar por parâmetro.

https://icon.kitchen/

Extrair e colar tudo que está dentro de `RES` em `/android/app/src/main/res`,
dando replace em tudo. No iOS é em `ios/Runner/Assets.xcassets/AppIcon.appiconset`.

⚠️ Por este caminho **ninguém remove o canal alfa por você** — confira o ícone de
1024 do iOS à mão (`PIL` tem que dizer `RGB`, nunca `RGBA`).

--------------------------------------------------------

# keystore & key.properties

O arquivo vai em **`android/key.properties`** (não em `android/app/`). Ele já está
no `.gitignore` — nunca commitar.

```
storePassword=<senha aleatória>
keyPassword=<mesma senha>
keyAlias=upload
storeFile=D:\\keys\\upload_keystore_<nome_do_app>.jks
```

- **O `.jks` fica em `D:\keys\`**, não dentro do projeto. As barras no `storeFile`
  são **duplas** (escape do Groovy).
- Gerar com o `keytool` — comando no [steps.md](steps.md).
- Depois de gerar, pegar o SHA-1 e o SHA-256 e colar no Firebase Console:
  `keytool -list -v -alias upload -keystore D:\keys\upload_keystore_<app>.jks`

## Conferir que o release saiu assinado de verdade

Vale o minuto que leva. Um AAB assinado com a chave de **debug** é recusado pelo
Play Console com uma mensagem que não diz a causa — foi o que aconteceu no
Famous Quest, porque o `build.gradle` do template vinha com
`signingConfig = signingConfigs.debug` no buildType release.

```bash
flutter build appbundle --release
```

O build tem que falhar se o `key.properties` não existir — e **não** gerar um
artefato assinado em debug. Para inspecionar o que saiu:

```bash
keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab
```

O `CN` tem que ser o do nosso certificado de upload, nunca `CN=Android Debug`.

> Checklist completo do que preparar antes de publicar:
> `docs/aprendizagem-publicacao/preparacao-de-app-novo.md` no workspace.