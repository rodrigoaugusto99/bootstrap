import 'dart:async';
import 'dart:convert';
import 'package:bootstrap/firestore/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bootstrap/app/app.locator.dart';
import 'package:bootstrap/app/app.logger.dart';
import 'package:bootstrap/models/notification_model.dart';
import 'package:bootstrap/services/auth_service.dart';
import 'package:bootstrap/services/user_service.dart';

class NotificationService {
  final _log = getLogger('NotificationService');
  final _firestore = FirebaseFirestore.instance;
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;

  Future<void> initNotifications() async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();

      await saveFcmTokenToFirestore(fcmToken);
      requestPermissions();
      _initPushNotifications();
      _initLocalNotifications();
      await getNotifications();

      _onTokenRefreshSubscription =
          FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        saveFcmTokenToFirestore(token);
        _log.i('FirebaseMessaging token: $token');
      });
    } on Exception catch (e) {
      _log.e(e);
    }
    subscribeToTopic("all");
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _handleForegroundNotificationTapped);

    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showLocalNotification(
    RemoteMessage message,
  ) async {
    try {
      AndroidNotificationDetails? androidPlatformChannelSpecifics;

      androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? 'Título da Notificação',
        message.notification?.body ?? 'Conteúdo da Notificação',
        platformChannelSpecifics,
        payload: json.encode(message.data),
      );
    } on Exception catch (e) {
      _log.e(e);
    }
  }

  Future _initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen(_handleBackgroundNotificationTapped);
    _onMessageSubscription =
        FirebaseMessaging.onMessage.listen(_handleForegroundNotification);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      _log.i('Handling initial notification');
      if (message == null) return;
      //redirectTo(json.encode(message.data));
    });
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
    } catch (e) {
      //
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } catch (e) {
      //
    }
  }

  Future<void> requestPermissions() async {
    try {
      await _firebaseMessaging.requestPermission();
    } catch (e) {
      _log.e(e);
    }
  }

  Future<void> _handleForegroundNotificationTapped(
    NotificationResponse notification,
  ) async {
    _log.i('Handling foreground notification TAPPED');
  }

//roda quando o app é aberto a partir da notificacao
  Future<void> _handleBackgroundNotificationTapped(
    RemoteMessage message,
  ) async {
    _log.i('Handling background notification TAPPED');
  }

//roda quando o app recebe notificacao em primeiro plano
  Future<void> _handleForegroundNotification(
    RemoteMessage message,
  ) async {
    _log.i('Handling foreground notification');
    _showLocalNotification(message);
  }

  void redirectTo(String? payload) {
    //_log.i(payload);
    if (payload == null) return;
  }

  Future<void> saveFcmTokenToFirestore(String? fcmToken) async {
    try {
      if (locator<AuthService>().currUser != null && fcmToken != null) {
        _log.i("FCM token: $fcmToken");
        final userDoc = _firestore
            .collection("users")
            .doc(locator<AuthService>().currUser!.uid);

        final docSnapshot = await userDoc.get();

        List<String> currentTokens = [];
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data.containsKey('fcmTokens')) {
            currentTokens = List<String>.from(data['fcmTokens'] ?? []);
          }
        }
        if (!currentTokens.contains(fcmToken)) {
          currentTokens.add(fcmToken);
          await userDoc.set({
            'fcmTokens': currentTokens,
          }, SetOptions(merge: true));
        }
      }
    } catch (error) {
      _log.e(error);
    }
  }

  Future<void> removeFcmTokenFromFirestore() async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      if (locator<AuthService>().currUser != null && fcmToken != null) {
        final userDoc = _firestore
            .collection("users")
            .doc(locator<AuthService>().currUser!.uid);

        final docSnapshot = await userDoc.get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data.containsKey('fcmTokens')) {
            List<String> currentTokens =
                List<String>.from(data['fcmTokens'] ?? []);
            currentTokens.removeWhere((token) => token == fcmToken);

            await userDoc.set({
              'fcmTokens': currentTokens,
            }, SetOptions(merge: true));
          }
        }
      }
    } catch (error) {
      _log.e("Error removing FCM token: $error");
    }
  }

  //FIRESTORE

  ValueNotifier<List<NotificationModel>> notifications = ValueNotifier([]);
  StreamSubscription? topicNotificationsSubscription;
  StreamSubscription? userNotificationsSubscription;
  ValueNotifier<bool> hasNotificationToRead = ValueNotifier(false);

  Future<void> markAllNotificationsAsRead() async {
    await Future.wait(notifications.value.map((notif) async {
      if (notif.isRead) return;

      if (notif.userId != null) {
        await updateNotification(notif.id, {
          'isRead': true,
        });
        notif.isRead = true;
        return;
      }

      DocumentReference notificationRef =
          FirebaseFirestore.instance.collection('notifications').doc(notif.id);
      //nessa notification, adicionar um doc com meu id na colecao "readBy" dela
      CollectionReference readByRef = notificationRef.collection('readBy');

      // Adiciona um documento na subcoleção 'readBy' com o ID igual ao 'userId'
      await readByRef.doc(locator<UserService>().user.value!.id).set({
        'readAt': FieldValue.serverTimestamp(),
      });
      notif.isRead = true;
    }));
    hasNotificationToRead.value = false;
  }

  Future<void> getNotifications() async {
    final hundredDaysAgo = Timestamp.fromDate(
      DateTime.now().subtract(const Duration(days: 99)),
    );
    final userService = locator<UserService>();
    if (userService.user.value!.createdAt == null) {
      _log.e('User has no createdAt date');
      return;
    }
    DateTime createdAt = userService.user.value!.createdAt!;
    // Query para 'all' notifications
    final topicQuery = FirebaseFirestore.instance
        .collection('notifications')
        .where("topic", isEqualTo: 'all')
        //tem q ter
        .where("createdAt", isGreaterThan: Timestamp.fromDate(createdAt));
    //.where("createdAt", isGreaterThanOrEqualTo: sevenDaysAgo);

    // Query para notifications específicas do usuário
    final userQuery = FirebaseFirestore.instance
        .collection('notifications')
        .where("userId", isEqualTo: locator<UserService>().user.value!.id)
        .where("createdAt", isGreaterThanOrEqualTo: hundredDaysAgo);

    // Execute ambas consultas em paralelo
    final results = await Future.wait([
      topicQuery.get(),
      userQuery.get(),
    ]);
    // Combine os documentos de ambas consultas, sem duplicatas
    final docs = <QueryDocumentSnapshot>{};
    for (var result in results) {
      docs.addAll(result.docs);
    }
    List<NotificationModel> nots = docs
        .map((doc) => NotificationModel.fromDocument(
            doc.id, doc.data() as Map<String, dynamic>))
        .toList();
    // Processa notificações

    await _processNotifications(nots);

    // Observa novas mudanças
    topicNotificationsSubscription =
        topicQuery.snapshots().skip(1).listen((snapshot) async {
      List<NotificationModel> nots = snapshot.docs
          .map((doc) => NotificationModel.fromDocument(doc.id, doc.data()))
          .toList();
      _processNotifications(nots);
    });
    userNotificationsSubscription =
        userQuery.snapshots().skip(1).listen((snapshot) async {
      List<NotificationModel> nots = snapshot.docs
          .map((doc) => NotificationModel.fromDocument(doc.id, doc.data()))
          .toList();
      _processNotifications(nots);
    });
  }

  final Map<String, NotificationModel> _combinedNotifications = {};
// Função para processar notificações e aplicar filtros de leitura e data
  Future<void> _processNotifications(List<NotificationModel> nots) async {
    _log.i('Processing notifications');
    //ve de forma paralela se as notificacoes estao lidas ou nao
    await Future.wait(nots.map((not) async {
      await setNotificationReadFlag(not);
      _combinedNotifications[not.id] = not;
    }));

//cria uma lista com todas as notificacoes que estão no mapa
    List<NotificationModel> allNotifications =
        _combinedNotifications.values.toList();

    //ordena
    allNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Atualiza os valores
    hasNotificationToRead.value = allNotifications.any((n) => !n.isRead);
    notifications.value = allNotifications;
  }

  Future<void> setNotificationReadFlag(NotificationModel not) async {
    if (not.topic == 'all') {
      final docRef =
          FirebaseFirestore.instance.collection('notifications').doc(not.id);

      final userId = locator<UserService>().user.value!.id;

      final readByUserDocumentSnapshot =
          await docRef.collection('readBy').doc(userId).get();

      bool isRead = readByUserDocumentSnapshot.exists;
      not.isRead = isRead;
    }
  }

  Future<void> dispose() async {
    await _onMessageOpenedAppSubscription?.cancel();
    await _onMessageSubscription?.cancel();
    await _onTokenRefreshSubscription?.cancel();
    await topicNotificationsSubscription?.cancel();
    await userNotificationsSubscription?.cancel();
    _onMessageOpenedAppSubscription = null;
    _onMessageSubscription = null;
    _onTokenRefreshSubscription = null;
    topicNotificationsSubscription = null;
    userNotificationsSubscription = null;
  }
}
