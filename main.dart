import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {

    setAudio();

    // TODO: implement initState
    super.initState();

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    //listen to audio duration
    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    //listen to audio position
    player.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  String? time(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if(duration.inHours > 0) hours,
      minutes,
      seconds
    ].join(":");
  }

  //for network audio
  Future setAudio() async {
    player.setReleaseMode(ReleaseMode.LOOP);
    String url = "";
    player.setUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image of the album or music
            Image.network("",width: double.infinity,height: 300,fit: BoxFit.cover,),
            SizedBox(height: 20,),
            Text("Flutter Audio",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
            SizedBox(height: 8,),
            Slider(
              min: 0,
                max: duration.inSeconds.toDouble(),
                value: duration.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await player.seek(position);

                  await player.resume();
                },
            ),
            SizedBox(height: 5,),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time(position) ?? ""),
                Text(time(duration - position) ?? "")
              ],
            ),),
            IconButton(
                onPressed: () async {
                  if(isPlaying){
                    await player.pause();
                  } else {
                    await player.resume();
                  }
                },
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 50,
            )
          ],
        ),
      ),
    );
  }
}


















