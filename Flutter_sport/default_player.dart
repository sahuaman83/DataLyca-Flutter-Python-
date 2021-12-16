import 'package:example/utils/mock_data.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_radio_slider/flutter_radio_slider.dart';

List jsonData = [
  {"EventName": "Pnt1", "MyPoint": "Y", "Time": 40},
  {"EventName": "Pnt1", "MyPoint": "N", "Time": 60},
  {"EventName": "Pnt2", "MyPoint": "Y", "Time": 120},
  {"EventName": "Pnt2", "MyPoint": "N", "Time": 130},
  {"EventName": "Pnt3", "MyPoint": "Y", "Time": 150},
  {"EventName": "Pnt4", "MyPoint": "Y", "Time": 160},
  {"EventName": "Pnt3", "MyPoint": "N", "Time": 210},
  {"EventName": "Pnt5", "MyPoint": "Y", "Time": 220},
];

List<Icon> scoreKeeper = [];
List<Text> pointsKeeper = [];

void scorekeeper() {
  for (var i = 0; i < jsonData.length; i++) {
    if (jsonData[i]['MyPoint'] == "Y") {
      scoreKeeper.add(Icon(
        Icons.flag_outlined,
        color: Colors.green,
      ));
      pointsKeeper.add(Text(
        jsonData[i]['EventName'],
        style: TextStyle(
          color: Colors.green,
        ),
      ));
    } else {
      scoreKeeper.add(Icon(
        Icons.flag_outlined,
        color: Colors.red,
      ));
      pointsKeeper.add(Text(
        jsonData[i]['EventName'],
        style: TextStyle(
          color: Colors.red,
        ),
      ));
    }
  }
}

class DefaultPlayer extends StatefulWidget {
  DefaultPlayer({Key? key}) : super(key: key);

  @override
  _DefaultPlayerState createState() => _DefaultPlayerState();
}

class _DefaultPlayerState extends State<DefaultPlayer> {
  late FlickManager flickManager;
  late VideoPlayerController _vpc;
  late Future<void> _vpcInit;
  int _videoPosition = 0;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: _vpc =
          VideoPlayerController.network(mockData["items"][0]["trailer_url"]),
    );
    _vpcInit = _vpc.initialize();

    _vpc.addListener(() {
      setState(() {
        _videoPosition = _vpc.value.position.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    flickManager.dispose();
    _vpc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = SliderTheme.of(context).copyWith(
      trackHeight: 3,
      overlayColor: Colors.red.withAlpha(32),
      activeTrackColor: Colors.blue[300],
      activeTickMarkColor: Colors.blue,
      inactiveTrackColor: Colors.grey[300],
      inactiveTickMarkColor: Colors.grey[200],
    );

    scorekeeper();

    return Container(
      child: Column(
        children: [
          FlickVideoPlayer(
            flickManager: flickManager,
            flickVideoWithControls: FlickVideoWithControls(
              controls: FlickPortraitControls(),
            ),
            flickVideoWithControlsFullscreen: FlickVideoWithControls(
              controls: FlickLandscapeControls(),
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (var i = 0; i < jsonData.length; i++) scoreKeeper[i],
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (var i = 0; i < jsonData.length; i++) pointsKeeper[i]
            ],
          ),
          FutureBuilder(
            future: _vpcInit,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Container(
                  child: Column(
                    children: <Widget>[
                      SliderTheme(
                        data: themeData,
                        child: Column(
                          children: [
                            RadioSlider(
                              onChanged: (value) {
                                setState(() {
                                  _videoPosition = value.toInt();
                                  // print(_videoPosition);
                                  _vpc.seekTo(Duration(
                                      seconds: jsonData[_videoPosition]
                                          ['Time']));
                                });
                              },
                              value: 0,
                              divisions: jsonData.length - 1,
                              outerCircle: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
