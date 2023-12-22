import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:camera/camera.dart';
import 'package:flutter_ar_food/models/datamodels/ar_camera_state.dart';
import 'package:flutter_ar_food/models/services/ar_core_service.dart';
import 'package:flutter_ar_food/models/services/camera_service.dart';
import 'package:flutter_ar_food/models/services/openai_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final arCameraViewModelProvider =
    StateNotifierProvider<ARCameraViewModel, ARCameraState>(
  (ref) => ARCameraViewModel(ref),
);

final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraService();
});

final arCoreServiceProvider = Provider<ARCoreService>((ref) {
  return ARCoreService();
});

final openAIServiceProvider = Provider<OpenAIService>((ref) {
  return OpenAIService();
});

class ARCameraViewModel extends StateNotifier<ARCameraState> {
  final Ref _ref;

  ARCameraViewModel(this._ref) : super(ARCameraState());

  Future<void> initializeCamera(CameraDescription camera) async {
    // カメラの初期化ロジック
    // 状態を更新するなどの操作
    await _ref.read(cameraServiceProvider).initializeCamera(camera);
  }

  Future<void> disposeCamera(CameraDescription camera) async {
    // カメラの終了ロジック
    _ref.read(cameraServiceProvider).dispose();
  }

  Future<void> startCameraPreview() async {
    // カメラのプレビューを開始する
    state = state.copyWith(isCameraPreviewActive: true);
  }

  Future<void> stopCameraPreview() async {
    // カメラのプレビューを停止する
    state = state.copyWith(isCameraPreviewActive: false);
  }

  Future<void> takePicture() async {
    // カメラサービスを使用して写真を撮影
    // var picture = await _read(cameraService).takePicture();
    // 状態を更新
    // state = state.copyWith(picture: picture);
  }

  void initializeARView(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) async {
    // ARビューの初期化処理
    await _ref.read(arCoreServiceProvider).onARViewCreated(
          arSessionManager,
          arObjectManager,
          arAnchorManager,
          arLocationManager,
        );
    await _ref.read(arCoreServiceProvider).copyAssetModelsToDocumentDirectory();
  }

  Future<void> placeARModel() async {
    // ARモデルの配置ロジック
  }

  Future<void> onRemoveARModel() async {
    // ARモデルを取り除く
    await _ref.read(arCoreServiceProvider).onRemoveEverything();
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
