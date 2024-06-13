import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duygu_durumuna_gore_muzik_oneri_sistemi/controllers/player_controller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Cam extends StatefulWidget {
  const Cam({Key? key});

  @override
  State<Cam> createState() => _CamState();
}

class _CamState extends State<Cam> {
  late List<CameraDescription> cameras;
  CameraDescription? selectedCamera;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  String predictionResult = '';
  final controller = PlayerController();
  dynamic randomSong;

  @override
  void initState() {
    super.initState();
    initializeCameras();
  }

  Future<List<DocumentSnapshot>> getSongsbyCategory(prediction) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('songs')
        .where('category', isEqualTo: prediction)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs;
    } else {
      print('Hata');
      return [];
    }
  }

  Future<void> initializeCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        selectedCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front);
        _controller =
            CameraController(selectedCamera!, ResolutionPreset.medium);
        _initializeControllerFuture = _controller.initialize();
        await _initializeControllerFuture;
      } else {
        // Kamera mevcut değil
        print("Kamera bulunamadı.");
      }
    } on CameraException catch (e) {
      // Kamera açılamıyor
      print("Kamera açılamadı: ${e.description}");
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> sendImageForPrediction() async {
    try {
      final XFile imageFile = await _controller.takePicture();
      final File file = File(imageFile.path);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://glad-katydid-namely.ngrok-free.app/predict'),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          file.path,
          filename: 'image.jpg',
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final prediction = jsonDecode(responseBody);
        setState(() {
          predictionResult = prediction['prediction'];
        });
      } else {
        print('Bir hata oluştu. İstek durumu: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Bir hata oluştu: $e');
      print('Hata izi: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedCamera == null || _initializeControllerFuture == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              sendImageForPrediction().then((_) async {
                final songs = await getSongsbyCategory(predictionResult);
                if (songs.isNotEmpty) {
                  final random = Random();
                  final randomSongIndex = random.nextInt(songs.length);
                  setState(() {
                    randomSong = songs[randomSongIndex];
                  });

                  controller.playSong(randomSong['url'], 0);
                } else {
                  print(
                      'Kategori değeri $predictionResult olan şarkı bulunamadı.');
                }
              });
            },
            child: Text('Müzik Öner'),
          ),
          Text(
            'Ruh haliniz: ${predictionResult == 'angry' ? 'Kizgin' : predictionResult == 'happy' ? 'Mutlu' : predictionResult == 'sad' ? 'Uzgun' : predictionResult == 'neutral' ? 'Notr' : 'Bilinmiyor'}',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            randomSong == null
                ? ''
                : 'Çalan Şarkı:' +
                    randomSong['artist'] +
                    '-' +
                    randomSong['song'],
            style: TextStyle(fontSize: 20),
          ),
        ],
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Kamera Uygulaması')),
      body: Cam(),
    ),
  ));
}
