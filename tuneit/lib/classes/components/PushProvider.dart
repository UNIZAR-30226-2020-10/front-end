import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/LateralMenu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tuneit/model/message.dart';
import 'package:tuneit/pages/notificaciones.dart';


class PushProvider{
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();




  final _mensajesStreamController = StreamController<Message>.broadcast();
  Stream<Message> get mensaje => _mensajesStreamController.stream;




  initNotifications() {

    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);


    _firebaseMessaging.getToken().then((token) {
      print('====== FCM token');
      print(token);
    });

    _firebaseMessaging.subscribeToTopic('all');


    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        /*setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });*/

        _mensajesStreamController.sink.add(Message(
            title: notification['title'], body: notification['body']));

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['notification'];
        /*setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));


        });*/
        _mensajesStreamController.sink.add(Message(
            title: notification['title'], body: notification['body']));

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final notification = message['notification'];
        _mensajesStreamController.sink.add(Message(
            title: notification['title'], body: notification['body']));


      },
    );
  }

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
    // send key to your server to allow server to use
    // this token to send push notifications
  }


  dispose(){
    _mensajesStreamController.close();
  }



}