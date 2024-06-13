// ignore_for_file: file_names

import 'dart:async';

import 'package:duygu_durumuna_gore_muzik_oneri_sistemi/consts/text_style.dart';
import 'package:duygu_durumuna_gore_muzik_oneri_sistemi/controllers/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AudioControlPanel extends StatefulWidget {
  bool isPlaying;

  final String currentSong;
  final String currentArtist;
  final PlayerController controller;

  AudioControlPanel({
    super.key,
    required this.controller,
    required this.isPlaying,
    required this.currentSong,
    required this.currentArtist,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AudioControlPanelState createState() => _AudioControlPanelState();
}

class _AudioControlPanelState extends State<AudioControlPanel> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Timer'ı iptal et
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "${widget.currentSong} - ${widget.currentArtist}",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: widget.isPlaying
                          ? const Icon(Icons.pause, color: Colors.white)
                          : const Icon(Icons.play_arrow, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          if (widget.isPlaying) {
                            widget.controller.pauseSong();
                            widget.isPlaying = false;
                          } else {
                            widget.controller.resumeSong();
                            widget.isPlaying = true;
                          }
                        });
                      },
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.volume_down,
                          color: Colors.white,
                        ),
                        Slider(
                          value: widget.controller.volume,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            setState(() {
                              double volume = value;
                              widget.controller.setVolume(volume);
                            });
                          },
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  widget.controller.position.seconds.toString().substring(0,
                      widget.controller.position.seconds.toString().length - 7),
                  style: myStyle(size: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 8,
                child: Slider(
                  value: widget.controller.position.toDouble(),
                  min: 0.0,
                  max: widget.controller.duration.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      widget.controller.seekSong(value);
                    });
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  widget.controller.duration.seconds.toString().substring(0,
                      widget.controller.duration.seconds.toString().length - 7),
                  style: myStyle(size: 12),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
