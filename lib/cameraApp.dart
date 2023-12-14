import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

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
  bool isCameraInitialized = false;
  bool isCameraPreviewActive = false;

  List<DetectedObject> detectedObjects = [];
  Size? _latestImageSize;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );
    _initializeControllerFuture = _controller.initialize().then((_) {
      _controller.resumePreview();
      setState(() {
        isCameraInitialized = true;
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
      appBar: AppBar(title: const Text('AR+Foods Camera')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // CameraPreview を全域に拡張
                      Positioned.fill(
                        child: (isCameraPreviewActive && isCameraInitialized)
                            ? CameraPreview(_controller)
                            : _appDescriptionWidget(),
                      ),
                      // CustomPaint も全域に拡張
                      if (_latestImageSize != null && isCameraInitialized)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: ObjectDetectionPainter(
                              detectedObjects,
                              _latestImageSize!,
                              Size(MediaQuery.of(context).size.width,
                                  MediaQuery.of(context).size.height),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                _cameraButtonWidget(context),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void startImageStream() {
    _controller.startImageStream((CameraImage image) {
      detectObjects(image);
    });
  }

  void stopImageStream() {
    _controller.stopImageStream();
  }

  Future<void> detectObjects(CameraImage image) async {
    final List<DetectedObject> newDetectedObjects = [];

    final options = ObjectDetectorOptions(
      mode: DetectionMode.stream,
      classifyObjects: true,
      multipleObjects: true,
    );
    final inputImage = getInputImageFromCameraImage(image);
    final objectDetector = ObjectDetector(options: options);

    if (inputImage == null) {
      return;
    }

    try {
      final objects = await objectDetector.processImage(inputImage);

      for (final object in objects) {
        newDetectedObjects.add(object);

        final rect = object.boundingBox;

        debugPrint(
            '検出された物体: ${object.labels.map((label) => label.text).join(', ')} at $rect');
      }
    } catch (e) {
      debugPrint('detect Object error: $e');
    } finally {
      setState(() {
        if (newDetectedObjects.isNotEmpty) {
          detectedObjects = newDetectedObjects;
        }
        _latestImageSize =
            Size(image.width.toDouble(), image.height.toDouble());
      });
      objectDetector.close();
      await Future.delayed(Duration(milliseconds: 1000));
    }
  }

  InputImage? getInputImageFromCameraImage(CameraImage image) {
    final sensorOrientation = widget.camera.sensorOrientation;
    final orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          orientations[_controller.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (widget.camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  Widget _cameraButtonWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        isCameraPreviewActive
            ? IconButton(
                icon: Icon(
                    isCameraPreviewActive ? Icons.arrow_back : Icons.start),
                onPressed: () async {
                  if (isCameraPreviewActive) {
                    _controller.pausePreview();
                    stopImageStream();
                    setState(() {
                      isCameraPreviewActive = false;
                    });
                  } else {
                    await _controller.resumePreview();
                    setState(() {
                      isCameraPreviewActive = true;
                    });
                  }
                },
              )
            : Container(width: 50),
        IconButton(
          icon: Icon(isCameraPreviewActive ? Icons.camera : Icons.camera_alt),
          onPressed: () async {
            if (isCameraPreviewActive) {
              stopImageStream();
              _controller.pausePreview();
              setState(() {
                isCameraPreviewActive = false;
              });
            } else {
              startImageStream();
              await _controller.resumePreview();
              setState(() {
                isCameraPreviewActive = true;
              });
            }
          },
        ),
        Container(width: 50),
      ],
    );
  }

  Widget _appDescriptionWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'このアプリでは、カメラを使って食品を認識し、その情報を表示します。カメラアイコンをタップしてカメラを起動してください。',
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ObjectDetectionPainter extends CustomPainter {
  final List<DetectedObject> detectedObjects;
  final Size originalImageSize;
  final Size displayImageSize;

  ObjectDetectionPainter(
      this.detectedObjects, this.originalImageSize, this.displayImageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final obj in detectedObjects) {
      final rect = obj.boundingBox;
      // オリジナルの座標系からディスプレイサイズに座標を変換
      final displayRect = Rect.fromLTRB(
        rect.left * displayImageSize.width / originalImageSize.width,
        rect.top * displayImageSize.height / originalImageSize.height,
        rect.right * displayImageSize.width / originalImageSize.width,
        rect.bottom * displayImageSize.height / originalImageSize.height,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
