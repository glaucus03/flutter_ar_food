import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:camera/camera.dart';
import 'package:flutter_ar_food/models/datamodels/ar_camera_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final arCameraViewModelProvider =
    StateNotifierProvider<ARCameraViewModel, ARCameraState>(
  (ref) => ARCameraViewModel(),
);

class ARCameraViewModel extends StateNotifier<ARCameraState> {
  ARCameraViewModel() : super(ARCameraState());

  Future<void> initializeCamera(CameraDescription camera) async {
    // カメラの初期化ロジック
    // 状態を更新するなどの操作
    final cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio:  false,
    );
    await cameraController.initialize();

    state = state.copyWith(
      cameraController:  cameraController,
    );
  }

  Future<void> startCameraPreview() async {
    // カメラのプレビューを開始する
    state = state.copyWith(
      isCameraPreviewActive: true
    );

  }

  Future<void> stopCameraPreview() async {
    // カメラのプレビューを停止する
    state = state.copyWith(
      isCameraPreviewActive: false
    );
  }

  Future<void> takePicture() async {
    // カメラサービスを使用して写真を撮影
    // var picture = await _read(cameraService).takePicture();
    // 状態を更新
    // state = state.copyWith(picture: picture);
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) async {
    // ARビューの初期化処理

    await arSessionManager.onInitialize(
      showFeaturePoints: true,
      showPlanes: true,
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
    );
    await arObjectManager.onInitialize();

    // arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    //  arObjectManager.onNodeTap = onNodeTapped;

    state = state.copyWith(
      arSessionManager: arSessionManager,
      arObjectManager: arObjectManager,
      arAnchorManager: arAnchorManager,
    );

    // await copyAssetModelsToDocumentDirectory();
  }

  Future<void> placeARModel() async {
    // ARモデルの配置ロジック
  }

  Future<void> onLeftFooterButtonPressed() async {
    // フッターの左ボタンを押下
    stopCameraPreview();
  }

  Future<void> onRightFooterButtonPressed() async {
    // フッターの右ボタンを押下
    //           if (viewModel.isCameraPreviewActive) {
    //            // カメラでの撮影を行う
    //            viewModelNotifier.takePicture();
    //           } else {
    //             // カメラプレビュー前の場合には、
    //            viewModelNotifier.startCameraPreview();
    //           }
    //         },
  }
}
