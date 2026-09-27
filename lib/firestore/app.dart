import 'package:bootstrap/services/app_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// app/infos: versão mínima e links das lojas (atualização forçada). Sem o documento,
// devolve null e o app segue sem checar versão.
Future<AppInfos?> getAppInfos() async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('app').doc('infos').get();
    final data = snapshot.data();
    if (data == null) return null;
    return AppInfos.fromMap(data);
  } catch (error) {
    rethrow;
  }
}
