import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:video_player/video_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class MyPlayer extends StatefulWidget {

  String name;

  MyPlayer(this.name);

  @override
  _MyPlayer createState() => _MyPlayer(name);
}

class _MyPlayer extends State<MyPlayer> {

  VideoPlayerController controller = VideoPlayerController.file(File(""));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = VideoPlayerController.file(File(name))..addListener(() {
      setState(() {

      });
    })..setLooping(true)
      ..initialize().then((value){
      controller.play();
    });
  }



  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int visible = 1;
  bool isPlaying = true;

  Duration current = Duration();

  @override
  Widget build(BuildContext context) {

    return controller != null && controller.value.isInitialized ?
    SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: buildVideo(),),
      ),
    ) :
    Container();
  }




  Widget buildVideo()
  {
    return GestureDetector(
      onTap: (){
        setState(() {
          if(visible == 1)
          {
            visible = 0;
          }
          else {
            visible = 1;
          }
        });
      },
      child: Stack(
        children: [
          Container(
            child: VideoPlayer(
                controller,
            ),
          ),


          visible == 1 ? showContent((){
            if(isPlaying == true)
            {
              setState((){
                isPlaying = false;
                controller.pause();
              });
            }
            else {
              setState((){
                isPlaying = true;
                controller.play();
              });
            }
          }) : Container(),

          visible == 1 ? showSeekBar() : Container(),
        ],
      ),
    );
  }

  Widget showContent(call)
  {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          IconButton(
            onPressed: (){
              controller.position.then((value){
                setState(() {
                  controller.seekTo(Duration(seconds: value!.inSeconds-10));
                });

              });
            },
            icon: Icon(
                Icons.skip_previous,
              size: 30,
              color: Colors.white,
            ),
          ),

          SizedBox(
            width: 30,
          ),

          FloatingActionButton(
            backgroundColor: Colors.black54,
            onPressed: (){
              call();
            },
            child: Icon(
              isPlaying == true ? Icons.pause : Icons.play_arrow,
            ),
          ),

          SizedBox(
            width: 30,
          ),


          IconButton(
            onPressed: (){
              controller.position.then((value){
                setState(() {
                  controller.seekTo(Duration(seconds: value!.inSeconds+10));
                });

              });
            },
            icon: Icon(
                Icons.skip_next,
              size: 30,
              color: Colors.white,
            ),
          ),


        ],
      ),
    );
  }


  Widget showSeekBar()
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        StreamBuilder(stream: controller.position.asStream(),
          builder: (BuildContext context, AsyncSnapshot<Duration?> snapshot) {
          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black45,
            ),
            child: snapshot.data != null ? ProgressBar(
                onSeek: (duration) {
                  controller.seekTo(duration);
                },
                baseBarColor: Colors.white,
                progressBarColor: Colors.redAccent,
                thumbColor: Colors.red,
                bufferedBarColor: Colors.white,
                thumbGlowColor: Colors.white,
                progress: Duration(milliseconds: snapshot.data!.inMilliseconds),
                total: Duration(milliseconds: controller.value.duration.inMilliseconds)) : Container(),
          );
          },
        )
      ],
    );
  }


  String name;
  //
  _MyPlayer(this.name);

}