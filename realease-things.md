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

