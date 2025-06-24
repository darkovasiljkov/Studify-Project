import 'package:camera/camera.dart';

class CameraService {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  Future<void> initialize(CameraDescription camera) async {
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  Future<String?> takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      return image.path;
    } catch (e) {
      print("Error capturing image: $e");
      return null;
    }
  }

  void dispose() {
    _controller.dispose();
  }

  CameraController get controller => _controller;

  Future<void> get initializeFuture => _initializeControllerFuture;
}