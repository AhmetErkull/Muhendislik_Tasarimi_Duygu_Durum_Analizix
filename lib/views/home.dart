import 'package:duygu_durumuna_gore_muzik_oneri_sistemi/consts/colors.dart';
import 'package:duygu_durumuna_gore_muzik_oneri_sistemi/consts/text_style.dart';
import 'package:duygu_durumuna_gore_muzik_oneri_sistemi/controllers/player_controller.dart';
import 'package:duygu_durumuna_gore_muzik_oneri_sistemi/widgets/audioControlPanel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = PlayerController();
  String _currentSong = '';
  String _currentArtist = '';
  bool _isControlPanelVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        title: Text(
          "Müzik Listesi",
          style: myStyle(family: bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('songs').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final songs = snapshot.data?.docs.reversed.toList();
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: songs!.length,
                      itemBuilder: (context, index) {
                        var song = songs[index];
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              tileColor: bgColor,
                              title: Text(
                                song['song'] ?? "",
                                style: myStyle(family: bold, size: 15),
                              ),
                              subtitle: Text(
                                song['artist'] ?? "",
                                style: myStyle(family: bold, size: 15),
                              ),
                              leading: const Icon(Icons.music_note,
                                  color: whiteColor, size: 26),
                              trailing: controller.playindex == index &&
                                      controller.isplaying == true
                                  ? const Icon(Icons.play_arrow,
                                      color: whiteColor, size: 26)
                                  : null,
                              onTap: () {
                                setState(() {
                                  controller.playSong(song['url'], index);
                                  _currentSong = song['song'] ?? '';
                                  _currentArtist = song['artist'] ?? '';
                                  _isControlPanelVisible = true;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_isControlPanelVisible)
                    AudioControlPanel(
                      controller: controller,
                      isPlaying: controller.isplaying,
                      currentSong: _currentSong,
                      currentArtist: _currentArtist,
                    ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
