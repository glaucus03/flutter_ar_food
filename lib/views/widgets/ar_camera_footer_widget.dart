import 'package:flutter/material.dart';
import 'package:flutter_ar_food/viewmodels/ar_camera_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ARCameraFooterWidget extends ConsumerWidget {
  const ARCameraFooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(arCameraViewModelProvider);
    final viewModelNotifier = ref.watch(arCameraViewModelProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: viewModel.isCameraPreviewActive,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              viewModelNotifier.onLeftFooterButtonPressed();
            },
          ),
        ),
        IconButton(
            icon: Icon(viewModel.isCameraPreviewActive
                ? Icons.camera
                : Icons.camera_alt),
            onPressed: () async {
              viewModelNotifier.onRightFooterButtonPressed();
            }),
        const Visibility(
          visible: false,
          maintainState: true,
          child: Icon(Icons.arrow_right)
        ),
      ],
    );
  }
}
