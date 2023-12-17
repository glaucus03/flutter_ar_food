import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_ar_food/views/pages/ar_camera_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(ProviderScope(
    child: MaterialApp(
      title: 'AR+Food Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ARCameraPage(camera: firstCamera),
    ),
  ));
}
