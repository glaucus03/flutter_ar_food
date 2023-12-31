import 'dart:io';

import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart' as vec;

class ARCoreService {
  late ARSessionManager? arSessionManager;
  late ARObjectManager? arObjectManager;
  late ARAnchorManager? arAnchorManager;
  late ARLocationManager? arLocationManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  Future<void> onRemoveEverything() async {
    for (var anchor in anchors) {
      arAnchorManager!.removeAnchor(anchor);
    }
    anchors = [];
  }

  onPanStarted(String nodeName) {
    debugPrint("Started panning node $nodeName");
  }

  onPanChanged(String nodeName) {
    debugPrint("Continued panning node $nodeName");
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    debugPrint("Ended panning node $nodeName");
  }

  onRotationStarted(String nodeName) {
    debugPrint("Started rotating node $nodeName");
  }

  onRotationChanged(String nodeName) {
    debugPrint("Continued rotating node $nodeName");
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    debugPrint("Ended rotating node $nodeName");
  }

  Future<void> onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) async {
    await arSessionManager.onInitialize(
      showFeaturePoints: true,
      showPlanes: true,
      showWorldOrigin: false,
      handlePans: true,
      handleRotation: true,
    );
    await arObjectManager.onInitialize();

    arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arAnchorManager = arAnchorManager;
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arLocationManager = arLocationManager;
  }

  Future<void> copyAssetModelsToDocumentDirectory() async {
    List<String> filesToCopy = [
      "assets/RiggedFigure.glb",
      "assets/RobotExpressive.glb",
      "assets/Fox.glb"
    ];

    final Directory docDir = await getApplicationDocumentsDirectory();
    final String docDirPath = docDir.path;

    await Future.wait(
      filesToCopy.map((String assetPath) async {
        String assetFilename = assetPath.split('/').last;
        File file = File('$docDirPath/$assetFilename');

        final assetBytes = await rootBundle.load(assetPath);
        final buffer = assetBytes.buffer;

        await file.writeAsBytes(
          buffer.asUint8List(
            assetBytes.offsetInBytes,
            assetBytes.lengthInBytes,
          ),
        );

        debugPrint("Copied $assetPath to ${file.path}");
      }),
    );

    debugPrint("Finished copying files to app's documents directory");
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere((hitTestResult) =>
        hitTestResult.type == ARHitTestResultType.plane ||
        hitTestResult.type == ARHitTestResultType.point);
    var newAnchor =
        ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
    bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);

    if (didAddAnchor != null) {
      anchors.add(newAnchor);
    } else {
      arSessionManager!.onError("Adding Anchor to Anchors failed");
    }

    var newNode = ARNode(
        type: NodeType.fileSystemAppFolderGLB,
        uri: "Fox.glb",
        scale: vec.Vector3(0.1, 0.1, 0.1),
        position: vec.Vector3(0.0, 0.0, 0.0),
        rotation: vec.Vector4(1.0, 0.0, 0.0, 0.0));
    bool? didAddNodeToAnchor =
        await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);

    if (didAddNodeToAnchor != null) {
      nodes.add(newNode);
    } else {
      arSessionManager!.onError("Adding Node to Anchor failed");
    }
  }
}
