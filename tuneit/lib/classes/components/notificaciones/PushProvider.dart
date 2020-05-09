import 'dart:async';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/model/message.dart';
import 'package:tuneit/pages/social/notificaciones.dart';









class PushProvider{
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String nuestro_token;




  final _mensajesStreamController = StreamController<Message>.broadcast();
  Stream<Message> get mensaje => _mensajesStreamController.stream;

  static final PushProvider _singleton = PushProvider._internal();

  factory PushProvider() {
    return _singleton;
  }

  String devolverToken(){
    return nuestro_token;
  }

  PushProvider._internal();




  initNotifications() {

    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);


    _firebaseMessaging.getToken().then((token) {


      nuestro_token=token;

      nuestro_token=nuestro_token.replaceFirst('\n','');

    });

    _firebaseMessaging.subscribeToTopic('all');


    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];

        _mensajesStreamController.sink.add(Message(
            title: notification['title'], body: notification['body']));

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['notification'];

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

  }


  dispose(){
    _mensajesStreamController.close();
  }



}