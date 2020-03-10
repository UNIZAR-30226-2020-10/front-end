import 'package:flutter/material.dart';
import 'package:tuneit/classes/LateralMenu.dart';

class Profile extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState ();
}


class _ProfilePageState extends State<Profile> {
  int _counter = 0;
  //----------------------------------------------------//

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Perfil'),
        centerTitle: true,
      ),
      drawer: MenuLateral(),
         // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
