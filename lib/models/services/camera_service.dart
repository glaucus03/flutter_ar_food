import 'package:camera/camera.dart';

class CameraService {
  CameraController? cameraController;

  Future<void> initializeCamera(CameraDescription camera) async {
    cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController?.initialize();
  }

  Future<void> startCameraPreview() async {
    if (cameraController != null && !cameraController!.value.isStreamingImages) {
      await cameraController?.startImageStream((CameraImage image) {
        // カメラからの画像ストリームを処理
      });
    }
  }

  Future<void> stopCameraPreview() async {
    if (cameraController != null && cameraController!.value.isStreamingImages) {
      await cameraController?.stopImageStream();
    }
  }

  void dispose() {
    cameraController?.dispose();
  }
}
