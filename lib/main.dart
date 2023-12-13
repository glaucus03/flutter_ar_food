import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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

// カメラアプリのウィジェット
class CameraApp extends StatefulWidget {
  final CameraDescription camera;

  const CameraApp({Key? key, required this.camera}) : super(key: key);

  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isCameraActive = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize().then((_) {
      setState(() {
        isCameraActive = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AR+Foods Camera')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                isCameraActive
                    ? Expanded(child: CameraPreview(_controller))
                    : _appDescriptionWidget(),
                _cameraButtonWidget(context)
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _cameraButtonWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(isCameraActive ? Icons.camera : Icons.camera_alt),
          onPressed: () async {
            if (isCameraActive) {
              //await _controller.stopImageStream(); // カメラストリームを停止
              setState(() {
                isCameraActive = false;
              });
            } else {
              try {
                await _controller.initialize();
                setState(() {
                  isCameraActive = true;
                });
              } catch (e) {
                print('カメラ初期化エラー: $e');
              }
            }
          },
        ),
      ],
    );
  }

  Widget _appDescriptionWidget() {
    return Expanded(
        child: Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'このアプリでは、カメラを使って食品を認識し、その情報を表示します。カメラアイコンをタップしてカメラを起動してください。',
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }
}
