import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:podcast_app/consts/colors.dart';
import 'package:podcast_app/consts/text_style.dart';
import 'package:podcast_app/controllers/player_controllers.dart';
import 'package:podcast_app/views/player.dart';

import '../consts/style.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context){
    var controller = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.search, color: whiteColor,)),
        ],
        leading: const Icon(Icons.sort_rounded, color: whiteColor,),
        title: Text(
          "PodCast",
          style: ourStyle(
            family: bold,
            size: 18,
        ),),
      ),
      body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL,
          ),
          builder: (BuildContext context, snapshot){
            if(snapshot.data == null) {
              return Center(
              child: CircularProgressIndicator(),
              );
             } else if (snapshot.data!.isEmpty){
              return Center(
                child: Text(
                  "No song found",
                  style: ourStyle(),
                ),
              );
             }else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length ,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      margin: EdgeInsets.only(bottom: 4),
                      child: Obx(
                            () => ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          tileColor: bgColor,
                          title: Text(
                           "${snapshot.data![index].displayNameWOExt}",
                            style: ourStyle(family: bold, size: 15),
                          ),
                          subtitle: Text(
                            "${snapshot.data![index].artist}",
                            style: ourStyle(family: regular, size: 12),
                          ),
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(Icons.music_note, size: 32, color: whiteColor,),
                          ),
                          trailing: controller.playIndex.value == index && controller.isPlaying.value ? const Icon(
                            Icons.play_arrow,
                            color: whiteColor,
                            size: 26,
                          ) : null,
                          onTap: (){
                            Get.to(() =>  Player(
                              data: snapshot.data!,
                            ),
                              transition: Transition.rightToLeft,
                            );
                            controller.playSong(snapshot.data![index].uri, index);
                          },
                        ),
                      ),
                    );
                  }
                ),
              );
            }
            },
      )
    );
  }
}