import 'package:flutter/material.dart';
import 'package:tuneit/classes/LateralMenu.dart';

class Equalizer extends StatefulWidget {
  @override
  _EqualizerPageState createState() => _EqualizerPageState ();
}


class _EqualizerPageState extends State<Equalizer> {
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
        title: Text('Ecualizador'),
        centerTitle: true,
      ),
      drawer: MenuLateral(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}