import 'package:tuneit/api/messaging.dart';

abstract class Notificacion{
  String devolverEmisor();
  String devolverMensaje();
  String devolverImagen();
  int devolverID();
}
Future sendNotification(String titulo,String cuerpo, String token_usuario) async {
  await Messaging.sendTo(
      title: titulo,
      body: cuerpo,
      fcmToken: token_usuario
    // fcmToken: fcmToken,
  );

}
