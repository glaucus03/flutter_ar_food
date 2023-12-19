import 'package:camera/camera.dart';
import 'package:flutter_ar_food/utils/types.dart';

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

  Future<void> startCameraPreview(List<CameraImageProcessor> processors) async {
    if (cameraController != null &&
        !cameraController!.value.isStreamingImages) {
      await cameraController?.startImageStream((CameraImage image) {
        // カメラからの画像ストリームを処理
        for (var processor in processors) {
          processor(image);
        }
      });
    }
  }

  Future<void> stopCameraPreview() async {
    if (cameraController != null && cameraController!.value.isStreamingImages) {
      // カメラからの画像ストリームを停止する
      await cameraController?.stopImageStream();
    }
  }

  void dispose() {
    cameraController?.dispose();
  }
}
