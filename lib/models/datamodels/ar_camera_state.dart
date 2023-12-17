import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';

class ARCameraState {
  final bool isCameraPreviewActive;
  final ARSessionManager? arSessionManager;
  final ARObjectManager? arObjectManager;
  final ARAnchorManager? arAnchorManager;

  ARCameraState({
    this.isCameraPreviewActive = false,
    this.arSessionManager,
    this.arObjectManager,
    this.arAnchorManager,
  });

  ARCameraState copyWith(
      {bool? isCameraPreviewActive,
      ARSessionManager? arSessionManager,
      ARObjectManager? arObjectManager,
      ARAnchorManager? arAnchorManager}) {
    return ARCameraState(
      isCameraPreviewActive:
          isCameraPreviewActive ?? this.isCameraPreviewActive,
      arSessionManager: arSessionManager ?? this.arSessionManager,
      arObjectManager: arObjectManager ?? this.arObjectManager,
      arAnchorManager: arAnchorManager ?? this.arAnchorManager,
    );
  }
}
