import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:tuneit/classes/components/audio/Audio.dart';
import 'package:tuneit/classes/components/playlist/Playlist.dart';
import 'package:tuneit/classes/components/podcast/Podcast.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaCancion.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaLista.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaPodcast.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/components/notificaciones/Peticion.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/audio/audioPlayer.dart';
import 'package:tuneit/pages/podcast/showPodcast.dart';
import 'package:tuneit/pages/songs/showList.dart';
import 'package:tuneit/widgets/errors.dart';

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
                        image: new NetworkImage(image),
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
        if(lista[index].name==ListaFavorita) {Globals.id_fav=lista[index].id.toString();}
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
        return elementOfList(context, func, arguments + [index], lista[index].image, lista[index].name == null? 'Name is null' : lista[index].name);
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
                builder: (context) => PlayerPage(audios:audios,indice: index, indetificadorLista: indetificadorLista,escanciones: musicPod,),

              ));
            },

            leading: GFAvatar(

              backgroundImage: NetworkImage(audios[index].devolverImagen()),
              backgroundColor: Colors.transparent,
              shape: GFAvatarShape.standard,

            ),
            title: Text(audios[index].devolverTitulo()),
            subtitle: Text(audios[index].devolverArtista() + ' | ' + audios[index].devolverGenero()),
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
            ):IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                launchInBrowser(audios[index].devolverTitulo(),audios[index].devolverArtista());
              },
            ),

          ),
        );

    },
  );

}

List<Widget> listaParaAudiosCategorias(BuildContext context,List<Audio> audios, String indetificadorLista,bool musicPod,Function choiceAction){
  return List.generate(
    audios.length,
        (index) {
      return
        Card(
          key: Key('$index'),
          child: new ListTile(
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayerPage(audios:audios,indice: index, indetificadorLista: indetificadorLista,escanciones: musicPod,),

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
                return optionMenuSongCategory.map((String choice){
                  return PopupMenuItem<String>(
                    value: (choice + "--"+audios[index].devolverID().toString()+"--"+indetificadorLista+"--"+index.toString()),
                    child: Text(choice),
                  );

                }).toList();
              },
            ):IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                launchInBrowser(audios[index].devolverTitulo(),audios[index].devolverArtista());
              },
            ),

          ),
        );

    },
  );

}


Widget listaParaNotificaciones(BuildContext context,List<Notificacion> list,anchura,altura){
  if(list.length>0){
    return Column(
      children:List.generate(
        list.length,
            (index) {
          return
            Card(
              key: Key('$index'),
              child: new ListTile(
                onTap:(){

                },
                leading: GFAvatar(

                  backgroundImage: NetworkImage(list[index].devolverImagen()),
                  backgroundColor: Colors.transparent,
                  shape: GFAvatarShape.standard,

                ),
                title: Text(list[index].devolverMensaje()),
                subtitle: Text(list[index].devolverEmisor()),


                trailing: Container(
                  width: anchura*0.25,
                  height: altura*0.25,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () async {
                          bool prueba= await reactNotificacion(list[index].devolverID().toString(),'Acepto');
                          if(prueba){
                            operacionExitoRecomendacion(context);

                          }
                          else{
                            mostrarError(context,'No se ha podido aceptar la petición');

                          }
                        },
                        icon:Icon(Icons.check_circle),
                        color:Colors.green,
                        tooltip: aceptar_mensaje,
                      ),
                      IconButton(

                        color:Colors.red,
                        onPressed: () async {
                          bool prueba= await reactNotificacion(list[index].devolverID().toString(),'Rechazo');
                          if(prueba){
                            operacionExitoRecomendacion(context);

                          }
                          else{

                            mostrarError(context,'No se ha podido rechazar la petición');

                          }

                        },
                        icon:Icon(Icons.cancel),
                        tooltip: rechazar_mensaje,
                      ),

                    ],
                  ),
                ),
              ),


            );

        },
      ),
    );

  }


  else{
    return Column(
      children: <Widget>[
        Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          Align(
          alignment: Alignment.centerLeft,
             child:Text("No se han encontrado notificaciones"),),
        ))

      ],

    );
  }


}
Widget listaParaAudiosCompartidos(BuildContext context,List<CompartidaCancion> audios, String indetificadorLista,Function choiceAction) {
  List<Audio> prueba = [];

  if (audios.length > 0) {
    return Column(
        children: List.generate(
      audios.length,
          (index) {
        return
          Card(
            key: Key('$index'),
            child: new ListTile(

              onTap: () {
                prueba.add(audios[index].cancion);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PlayerPage(audios: prueba,
                        indice: index,
                        indetificadorLista: indetificadorLista,
                        escanciones: true,),

                ));
              },

              leading: GFAvatar(
                backgroundImage: NetworkImage(
                    audios[index].cancion.devolverImagen()),
                backgroundColor: Colors.transparent,
                shape: GFAvatarShape.standard,

              ),
              title: Text(audios[index].cancion.devolverTitulo()),
              subtitle: Text("Recomendada por " + audios[index].emisor.name),
              trailing: Container(
                height: 100,
                width: 100,
                child: Row(
                  children: <Widget>[
                    PopupMenuButton<String>(
                      onSelected: choiceAction,
                      itemBuilder: (BuildContext context) {
                        return optionMenuSongCategory.map((String choice) {
                          return PopupMenuItem<String>(
                            value: (choice + "--" +
                                audios[index].devolverID().toString() + "--" +
                                indetificadorLista + "--" + index.toString()),
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                    IconButton(
                      onPressed: () async {
                        bool resultado = await canciones_compartidas_eliminar(
                            audios[index].id.toString());
                        if (resultado) {
                          operacionExitoRecomendacion(context);
                        }
                        else {
                          mostrarError(context,
                              'No se ha podido eliminar la recomendación');
                        }
                      },
                      icon: Icon(Icons.cancel),
                      color: Colors.red,
                      tooltip: rechazar_mensaje,
                    ),
                  ],
                ),
              ),

            ),
          );
      },
    ),
    );
  }
  else{
    return Column(
      children: <Widget>[
        Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
          alignment: Alignment.centerLeft,
            child:Text("No se han encontrado recomendaciones"),
        )))

      ],

    );
  }

}


Widget listaParaListasCompartidos(BuildContext context,List<CompartidaLista> listas) {
  if (listas.length > 0) {
    return Column(
        children:List.generate(
    listas.length,
        (index) {
      return
        Card(
          key: Key('$index'),
          child: new ListTile(

            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ShowList(
                        indetificadorLista: listas[index].lista.id.toString(),
                        list_title: listas[index].lista.name,
                        esAmigo:false),

              ));
            },

            leading: GFAvatar(
              backgroundImage: NetworkImage(listas[index].emisor.photo),
              backgroundColor: Colors.transparent,
              shape: GFAvatarShape.standard,

            ),
            title: Text(listas[index].lista.name),
            subtitle: Text("Recomendada por " + listas[index].emisor.name),
            trailing: Container(
              height: 100,
              width: 100,
              child: Row(
                children: <Widget>[
                  IconButton(
                  color:Colors.green,
                  tooltip: aceptar_mensaje,
                    icon: Icon(Icons.check_circle),
                    onPressed: () async {
                      bool resultado = await agregarLista(
                          listas[index].lista.id.toString());
                      if (resultado) {
                        operacionExitoRecomendacion(context);
                        resultado = await dejarDeCompartirLista(
                            listas[index].id.toString());
                      }
                      else {
                        mostrarError(context,
                            'No se ha podido agregar la recomendación');
                      }
                    },
                  ),
                  IconButton(
                    onPressed: () async {
                      bool resultado = await dejarDeCompartirLista(
                          listas[index].id.toString());
                      if (resultado) {
                        operacionExitoRecomendacion(context);
                      }
                      else {
                        mostrarError(context,
                            'No se ha podido eliminar la recomendación');
                      }
                    },
                    icon: Icon(Icons.cancel),
                    color: Colors.red,
                    tooltip: rechazar_mensaje,
                  ),
                ],
              ),
            ),

          ),
        );
    },
  ),
    );
}

  else{
    return Column(
      children: <Widget>[
        Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:Align(
          alignment: Alignment.centerLeft,
           child: Text("No se han encontrado recomendaciones"),)
          ))

      ],

    );
  }

}

Widget listaPodcastCompartidos(BuildContext context,List<CompartidaPodcast> listas) {
  if (listas.length > 0) {
    return Column(
      children:List.generate(
        listas.length,
            (index) {
          return
            Card(
              key: Key('$index'),
              child: new ListTile(

                onTap: () {
                 if(listas[index].mi_podcast.name!=null&&listas[index].mi_podcast.id!=null){
                   Navigator.of(context).push(MaterialPageRoute(
                     builder: (context) => ShowPodcast(podcId: listas[index].podcast, podcName: listas[index].mi_podcast.name),
                   ));
                 }
                },

                leading: GFAvatar(
                  backgroundImage: NetworkImage(listas[index].mi_podcast.image==null?'https://i.blogs.es/6c558d/luna-400mpx/450_1000.jpg':listas[index].mi_podcast.image),
                  backgroundColor: Colors.transparent,
                  shape: GFAvatarShape.standard,

                ),
                title: Text(listas[index].mi_podcast.name==null?'Cargando recomendacion':listas[index].mi_podcast.name),
                subtitle: Text("Recomendada por " + listas[index].emisor.name),
                trailing: Container(
                  height: 100,
                  width: 100,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.check_circle),
                        onPressed: () async {
                          bool favorito = await checkFav(listas[index].podcast);
                          bool resultado = await dejarDeCompartirPodcast(listas[index].devolverID().toString());
                          if (!favorito) {
                            isFav(listas[index].podcast,listas[index].mi_podcast.name);
                          }
                          operacionExitoRecomendacion(context);

                        },
                          color:Colors.green,
                          tooltip: aceptar_mensaje
                      ),
                      IconButton(
                        onPressed: () async {
                          bool resultado = await dejarDeCompartirPodcast(listas[index].devolverID().toString());
                          if (resultado) {
                            operacionExitoRecomendacion(context);
                          }
                          else {
                            mostrarError(context,
                                'No se ha podido eliminar la recomendación');
                          }
                        },
                        icon: Icon(Icons.cancel),
                        color: Colors.red,
                        tooltip: rechazar_mensaje,
                      ),
                    ],
                  ),
                ),

              ),
            );
        },
      ),
    );
  }

  else{
    return Column(
      children: <Widget>[
        Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:Align(
              alignment: Alignment.centerLeft,
              child: Text("No se han recomendaciones"),)
        ))

      ],

    );
  }

}



