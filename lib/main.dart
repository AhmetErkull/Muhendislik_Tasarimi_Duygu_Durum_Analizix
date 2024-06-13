import 'package:duygu_durumuna_gore_muzik_oneri_sistemi/views/cam.dart';
import 'package:duygu_durumuna_gore_muzik_oneri_sistemi/views/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

int _index = 0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Duygu Durumuna Göre Müzik Öneri Sistemi',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent, elevation: 0),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 211, 204, 223)),
        useMaterial3: true,
      ),
      home: const MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0 && _index == 1) {
          setState(() {
            _index--;
          });
        } else if (details.delta.dx < 0 && _index == 0) {
          setState(() {
            _index++;
          });
        }
      },
      child: Scaffold(
        body: _index == 0 ? const Home() : const Cam(),
      ),
    );
  }
}
