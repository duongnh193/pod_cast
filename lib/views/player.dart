
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:podcast_app/consts/colors.dart';
import 'package:podcast_app/consts/style.dart';
import 'package:podcast_app/consts/text_style.dart';
import 'package:podcast_app/controllers/player_controllers.dart';


class Player extends StatelessWidget{
  final List<SongModel> data;
  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context){
    var controller = Get.find<PlayerController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(8 , 8, 8, 0),
        child: Column(
          children: [
            Obx(
            () => Expanded(
                  child: Container(
                    height: 300,
                    width: 300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: QueryArtworkWidget(
                      id: data[controller.playIndex.value].id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      nullArtworkWidget: const Icon(Icons.music_note, size: 50, color: whiteColor,),
                    ),
                  )),
            ),
            SizedBox(height: 12),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16))
                  ),
                  child: Obx(
                    () => Column(
                      children: [
                        SizedBox(height: 12,),
                        Text(
                          data[controller.playIndex.value].displayNameWOExt,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: ourStyle(
                            color: bgDarkColor,
                            size: 24,
                            family: bold,
                          ),
                        ),
                        Text(
                          data[controller.playIndex.value].artist.toString(),
                          style: ourStyle(
                            color: bgDarkColor,
                            size: 20,
                            family: regular,
                          ),
                        ),
                        SizedBox(height: 12,),
                        Obx(
                          () => Row(
                            children: [
                              Text(
                                controller.position.value,
                                style: ourStyle(
                                  color: bgDarkColor
                                ),
                              ),
                              Expanded(
                                  child: Slider(
                                      thumbColor: sliderColor,
                                      inactiveColor: bgColor,
                                      activeColor: sliderColor,
                                      min: const Duration(seconds: 0).inSeconds.toDouble(),
                                      max: controller.max.value,
                                      value: controller.value.value,
                                      onChanged: (newValue){
                                        controller.changeDurationToSeconds(newValue.toInt());
                                        newValue = newValue;
                                      }
                                      )),
                              Text(
                                controller.duration.value,
                                style: ourStyle(
                                    color: bgDarkColor
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: (){
                                  controller.playSong(data[controller.playIndex.value - 1].uri, controller.playIndex.value - 1);
                                },
                                icon: Icon(Icons.skip_previous_rounded, size: 44, color: bgDarkColor,)),
                            Obx(
                               () => CircleAvatar(
                                radius: 35,
                                backgroundColor: bgDarkColor,
                                child: Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                      onPressed: (){
                                        if (controller.isPlaying.value){
                                          controller.audioPlayer.pause();
                                          controller.isPlaying(false);
                                        } else {
                                          controller.audioPlayer.play();
                                          controller.isPlaying(true);
                                        }
                                      },
                                      icon: controller.isPlaying.value ? Icon(Icons.pause, color: whiteColor,) : Icon(Icons.play_arrow_rounded, color: whiteColor,))
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: (){
                                  controller.playSong(data[controller.playIndex.value + 1].uri, controller.playIndex.value + 1);
                                },
                                icon: Icon(Icons.skip_next_rounded, size: 44, color: bgDarkColor,)),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}