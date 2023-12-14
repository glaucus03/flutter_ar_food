import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_ar_food/cameraApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      title: 'AR+Food Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CameraApp(camera: firstCamera),
    ),
  );
}
