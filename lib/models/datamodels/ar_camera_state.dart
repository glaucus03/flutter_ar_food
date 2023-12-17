import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:camera/camera.dart';

class ARCameraState {
  final bool isCameraPreviewActive;
  final ARSessionManager? arSessionManager;
  final ARObjectManager? arObjectManager;
  final ARAnchorManager? arAnchorManager;

  final List<ARNode>? arNodes;
  final List<ARAnchor>? arAnchors;

  late CameraController? cameraController;

  ARCameraState({
    this.isCameraPreviewActive = false,
    this.arSessionManager,
    this.arObjectManager,
    this.arAnchorManager,
    this.arNodes,
    this.arAnchors,
    this.cameraController,
  });

  ARCameraState copyWith({
    bool? isCameraPreviewActive,
    ARSessionManager? arSessionManager,
    ARObjectManager? arObjectManager,
    ARAnchorManager? arAnchorManager,
    List<ARNode>? arNodes,
    List<ARAnchor>? arAnchors,
    CameraController? cameraController,
  }) {
    return ARCameraState(
      isCameraPreviewActive:
          isCameraPreviewActive ?? this.isCameraPreviewActive,
      arSessionManager: arSessionManager ?? this.arSessionManager,
      arObjectManager: arObjectManager ?? this.arObjectManager,
      arAnchorManager: arAnchorManager ?? this.arAnchorManager,
      arNodes: arNodes ?? this.arNodes,
      arAnchors: arAnchors ?? this.arAnchors,
      cameraController: cameraController ?? this.cameraController,
    );
  }
}
