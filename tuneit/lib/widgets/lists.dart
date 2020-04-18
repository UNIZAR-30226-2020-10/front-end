import 'package:flutter/material.dart';

//------------------------------------------------------------------------------
// Widget de un único elemento de una lista sin comportamiento (NO USAR)
Widget elementOfList2 (String image, String name) {
  return new Container(
    decoration: new BoxDecoration(
        color: Colors.white10,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(8.0),
          bottomLeft: const Radius.circular(8.0),
          bottomRight: const Radius.circular(8.0),
        )
    ),
    child: Center(
        child: Column(
            children: <Widget>[
              Flexible(
                  flex: 5,
                  child: new Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(
                        image: image == null? new AssetImage('assets/PorDefecto.png') : new NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(8.0),
                        topRight: const Radius.circular(8.0),
                        bottomLeft: const Radius.circular(8.0),
                        bottomRight: const Radius.circular(8.0),
                      )
                    ),
                  )
              ),
              Flexible(
                flex: 1,
                child: Center(
                    child: FittedBox(
                      child: Text(name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
              ),
            ]
        )
    ),
    margin: const EdgeInsets.all(8.0),
    padding: const EdgeInsets.all(1),
  );
}

// Widget de un único elemento de una lista con comportamiento (NO USAR)
Widget elementOfList (BuildContext context, Function func, List arguments, String image, String name) {
  return new GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      Function.apply(func, arguments);
    },
    child: elementOfList2(image, name),
  );
}

// Widget con una lista funcional completa
//  func: función que describe el comportamiento de onTap de cada elemento
//  arguments: lista con los argumentos de func (EN ORDEN)
//    IMPORTANTE: por defecto se pasa siempre 'int index'
// Ejemplo en pages/playlists.dart
Widget completeList (List lista, Function func, List arguments) {
  return GridView.builder(
      //scrollDirection: Axis.vertical,
      //shrinkWrap: true,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: lista.length,
      itemBuilder: (BuildContext context, int index) {
        return elementOfList(context, func, arguments + [index], lista[index].image, lista[index].name);
      }
  );
}

//------------------------------------------------------------------------------