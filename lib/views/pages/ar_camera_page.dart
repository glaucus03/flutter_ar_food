import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_food/viewmodels/ar_camera_view_model.dart';
import 'package:flutter_ar_food/views/widgets/ar_camera_center_widget.dart';
import 'package:flutter_ar_food/views/widgets/ar_camera_footer_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ARCameraPage extends HookConsumerWidget {
  final CameraDescription camera;

  const ARCameraPage({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(arCameraViewModelProvider);
    final viewModelNotifier = ref.watch(arCameraViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('AR+Foods Camera')),
      body: FutureBuilder<void>(
        future: viewModelNotifier.initializeCamera(camera),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const Column(children: [
              Expanded(
                child: Stack(
                  children: [ARCameraCenterWidget()],
                ),
              ),
              ARCameraFooterWidget(),
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
