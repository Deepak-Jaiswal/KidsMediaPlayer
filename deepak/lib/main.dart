import 'dart:io';

import 'package:deepak/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> initializePlayer() async {}

  @override
  Widget build(BuildContext context) {
    if (!Directory("${_kids.path}").existsSync()) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Videos"),
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: 60.0),
          child: const Center(
            child: Text(
              "All video should appear here", style: TextStyle(
                fontSize: 18.0
            ),),
          ),
        ),
      );
    } else {
      var imageList = _kids.listSync().map((item) => item.path).where((
          item) => item.endsWith(".mp4")).toList(growable: false);

      if (imageList.length > 0) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Kids Media Player"),
            elevation: 0,
          ),

          body: SingleChildScrollView(
            child: Column(
              children: imageList.map((e){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyPlayer(e)));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      File(e).path.split('/').last,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,

                      ),
                    ),
                  ),
                );

              }).toList(),
            ),
          ),

        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text("Videos"),
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 60.0),
              child: Text("Sorry, No Videos Where Found.", style: TextStyle(
                  fontSize: 18.0
              ),),
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {

  }


  final Directory _kids = Directory('/storage/emulated/0/kids');


}
