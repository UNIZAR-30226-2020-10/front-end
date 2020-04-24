import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/pages/audio/audioPlayer.dart';

class bottomExpandableAudio extends StatefulWidget {
  bottomExpandableAudio({
    Key key}) : super(key: key);

  @override
  _bottomExpandableAudio createState() => _bottomExpandableAudio();
}

class _bottomExpandableAudio extends State<bottomExpandableAudio> with SingleTickerProviderStateMixin  {
  BottomBarController controller = null;
  PlayerPage llamadastream = PlayerPage();
  Duration _position;
  Duration _duration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = BottomBarController(vsync: this, dragLength: 170, snap: true);

  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //stream: llamadastream.devolverPlayer,
        builder:(context,snapshot) {
          final String artista = null;
          if(!snapshot.hasData){
            String artista = "Artista Desconocido" ;
          }
          else{

          }
          return PreferredSize(
            preferredSize: Size.fromHeight(controller.dragLength),
            child: BottomExpandableAppBar(
                controller: controller,
                expandedHeight: controller.dragLength,
                horizontalMargin: 0,
                expandedBackColor: Theme
                    .of(context)
                    .backgroundColor,
                attachSide: Side.Bottom,
                // Your bottom sheet code here
                expandedBody: GestureDetector(
                    onVerticalDragUpdate: controller.onDrag,
                    onVerticalDragEnd: controller.onDragEnd,
                    child: Card(

                      child: Column(

                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[

                            const ListTile(

                              leading: Icon(Icons.album, size: 50),

                              title: Text(
                                  'Nombre de la Canción Correspondiente'),

                              subtitle: Text(
                                  'artista'),

                            ),
                            SizedBox(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 5),
                                  trackHeight: 3,
                                  thumbColor: Colors.pink,
                                  inactiveTrackColor: Colors.grey,
                                  activeTrackColor: Colors.pink,
                                  overlayColor: Colors.transparent,
                                ),
                                child: Slider(
                                  value:
                                  _position != null ? _position.inMilliseconds
                                      .toDouble() : 0.0,
                                  min: 0.0,
                                  max:
                                  _duration != null ? _duration.inMilliseconds
                                      .toDouble() : 0.0,
                                  onChanged: (double value) async {
                                    //final Result result = await _audioPlayer
                                    //    .seekPosition(Duration(milliseconds: value.toInt()));
                                    //if (result == Result.FAIL) {
                                    //  print(
                                    //      "you tried to call audio conrolling methods on released audio player :(");
                                    //} else if (result == Result.ERROR) {
                                    //  print("something went wrong in seek :(");
                                    //}
                                    //_position = Duration(milliseconds: value.toInt());
                                  },
                                ),
                              ),
                            ),
                            new Row(mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(icon: Icon(Icons.skip_previous),
                                  onPressed: () {},),
                                IconButton(icon: Icon(Icons.repeat),
                                  onPressed: () {},),
                                IconButton(icon: Icon(Icons.play_circle_filled),
                                  onPressed: () {snapshot.data._audioPlayer.resume();},),
                                IconButton(icon: Icon(Icons.shuffle),
                                  onPressed: () {},),
                                IconButton(icon: Icon(Icons.skip_next),
                                  onPressed: () {},)
                              ],

                            ),

                          ]),

                    )
                )
            ),
          );
        }
        );
  }
}