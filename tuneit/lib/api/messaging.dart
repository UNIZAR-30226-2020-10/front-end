import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

class Messaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey =
      'AAAAYVSoiZA:APA91bH0t7QF885p70vGUwCIq8qEYSF8WYQrMnrN8LQYJ7z3DRSOrqLsg6eKarJPAmOdrbagW4HVaQXzRZxdUWr0JopbF6X9jpFCdd2EfkqlSjvn4O9PHrPx7ADZRn92lS8XsuzyEipk';
      //AAAAYVSoiZA:APA91bH0t7QF885p70vGUwCIq8qEYSF8WYQrMnrN8LQYJ7z3DRSOrqLsg6eKarJPAmOdrbagW4HVaQXzRZxdUWr0JopbF6X9jpFCdd2EfkqlSjvn4O9PHrPx7ADZRn92lS8XsuzyEipk

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
          {@required String title,
          @required String body,
          @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
