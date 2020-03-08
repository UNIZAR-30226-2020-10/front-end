import 'package:flutter/material.dart';
import 'package:tuneit/classes/LateralMenu.dart';

class PlayLists extends StatefulWidget {
  @override
  _PlayListsState createState() => _PlayListsState();
}

class _PlayListsState extends State<PlayLists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de reproduccion'),
        centerTitle: true,
      ),
      drawer: MenuLateral(),
      body: Row(
          children: <Widget>[
            Expanded(
                flex: 5,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pushNamed(context, '/list',arguments: {
                      'list_title':'Favoritos'
                    });
                  },
                  child: Container(
                    color: Colors.black87,
                    child: Center(
                        child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Favoritos',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                                ),
                              ),

                              Expanded(
                                flex: 8,
                                child: Image(
                                  image: NetworkImage('https://elcultural.com/wp-content/uploads/2020/01/a-34-696x390.jpg'),
                                ),
                              ),
                            ]
                        )
                    ),
                    margin: const EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    width: 100.0,
                    height: 230.0,
                  ),
                )
            ),
            Expanded(
              flex: 5,
              child:
              Container(
                color: Colors.black87,
                child: Center(
                    child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Mi lista',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Image(
                              image: NetworkImage('https://www.neo2.com/wp-content/uploads/2019/06/J-Balvin-Bad-Bunny-Oasis-01-.jpg'),
                            ),
                          ),
                        ]
                    )
                ),
                margin: const EdgeInsets.all(10.0),
                alignment: Alignment.centerRight,
                width: 100.0,
                height: 230.0,
              ),
            ),
          ]
      ),
    );
  }
}