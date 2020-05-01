import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/audio/audioPlayer.dart';

import 'AutoScrollableText.dart';

//------------------------------------------------------------------------------
// Widget de un único elemento de una lista sin comportamiento (NO USAR)
Widget elementOfList2 (String image, String name) {
  return new Container(
    height: 150,
    width: 150,
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
                  flex: 6,
                  child: new Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(
                        image: image == null? new AssetImage(imagenPorDefecto) : new NetworkImage(image),
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
                child: MarqueeWidget(
                  child: Text(name, style: TextStyle(fontSize: 15, fontFamily: 'RobotoMono', color: ColorSets.colorText),),
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
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: lista.length,
      itemBuilder: (BuildContext context, int index) {
        if(lista[index].name==ListaFavorita) {Globals.id_fav=lista[index].id.toString(); print(Globals.id_fav);}
        return elementOfList(context, func, arguments + [index], lista[index].image, lista[index].name);
      }
  );
}

Widget completeListNotScrollable (List lista, Function func, List arguments) {
  return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: lista.length,
      itemBuilder: (BuildContext context, int index) {
        return elementOfList(context, func, arguments + [index], lista[index].image, lista[index].name);
      }
  );
}

Widget completeListHorizontal (List lista, Function func, List arguments) {
  return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
      itemCount: lista.length,
      itemBuilder: (BuildContext context, int index) {
        return elementOfList(context, func, arguments + [index], lista[index].image, lista[index].name);
      }
  );
}

//------------------------------------------------------------------------------


List<Widget> listaParaAudios(BuildContext context,List<Audio> audios, String indetificadorLista,bool musicPod,Function choiceAction){
  return List.generate(
    audios.length,
        (index) {
      return
        Card(
          key: Key('$index'),
          child: new ListTile(
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayerPage(audios:audios,indice: index),

              ));
            },

            leading: GFAvatar(

              backgroundImage: NetworkImage(audios[index].devolverImagen()),
              backgroundColor: Colors.transparent,
              shape: GFAvatarShape.standard,

            ),
            title: Text(audios[index].devolverTitulo()),
            subtitle: Text(audios[index].devolverArtista()),
            trailing: musicPod? PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context){
                return optionMenuSong.map((String choice){
                  return PopupMenuItem<String>(
                    value: (choice + "--"+audios[index].devolverID().toString()+"--"+indetificadorLista+"--"+index.toString()),
                    child: Text(choice),
                  );

                }).toList();
              },
            ):Container( width: 0,height: 0,),

          ),
        );

    },
  );

}
