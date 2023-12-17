import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_food/viewmodels/ar_camera_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ARCameraCenterWidget extends ConsumerWidget {
  const ARCameraCenterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(arCameraViewModelProvider);

    return viewModel.isCameraPreviewActive
        ? _arCameraPreview(context, ref)
        : _buildInitializeView(context, ref);
  }

  Widget _buildInitializeView(BuildContext context, WidgetRef ref) {
    final viewModelNotifier = ref.watch(arCameraViewModelProvider.notifier);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'ARカメラを開始するには、下のボタンを押してください。',
              textAlign: TextAlign.center,
            )),
        ElevatedButton(
          onPressed: () => {viewModelNotifier.initializeCamera()},
          child: const Text('カメラスタート'),
        )
      ],
    );
  }

  Widget _arCameraPreview(BuildContext context, WidgetRef ref) {
    final viewModelNotifier = ref.watch(arCameraViewModelProvider.notifier);
    return ARView(
        onARViewCreated: viewModelNotifier.onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical);
  }
}
