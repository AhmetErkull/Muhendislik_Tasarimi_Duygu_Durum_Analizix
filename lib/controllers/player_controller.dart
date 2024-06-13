// ignore_for_file: avoid_print

import 'package:just_audio/just_audio.dart';

class PlayerController {
  int playindex = 0;
  bool isplaying = false;
  final audioPlayer = AudioPlayer();
  int duration = 0;
  int position = 0;
  double _volume = 1.0; // Default volume

  double get volume => _volume;

  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0); // Ensure volume is between 0 and 1
    audioPlayer.setVolume(_volume);
  }

  void playSong(String? uri, int index) {
    playindex = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isplaying = true;
      updatePosition();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void pauseSong() {
    audioPlayer.pause();
    isplaying = false;
  }

  void resumeSong() {
    audioPlayer.play();
    isplaying = true;
  }

  void seekSong(double value) {
    int newPosition = value.toInt();
    audioPlayer.seek(Duration(seconds: newPosition));
  }

  void updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration = d!.inSeconds;
    });
    audioPlayer.positionStream.listen((p) {
      position = p.inSeconds;
    });
  }

  void changeDurationToSeconds(int seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
