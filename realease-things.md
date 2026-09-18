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

## link para gerar o icone

https://icon.kitchen/

## arquivos

extrair, colar tudo que ta dentro de RES dentro do /android/res.
dar replace em tudo

no ios, eh no ios/flutter/runner/assets.scassets/appIcon.appiconset

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