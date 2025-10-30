import 'package:flutter_piano_audio_detection/flutter_piano_audio_detection.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service để nhận diện âm thanh piano từ microphone
class PianoDetectionService {
  final FlutterPianoAudioDetection _fpad = FlutterPianoAudioDetection();
  Stream<List<dynamic>>? _resultStream;
  bool _isReady = false;
  bool _isRecording = false;
  double _volumeThreshold = 0.5; // Ngưỡng mặc định 70%

  bool get isReady => _isReady;
  bool get isRecording => _isRecording;
  double get volumeThreshold => _volumeThreshold;

  /// Khởi tạo engine nhận diện piano
  Future<bool> initialize() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        await _fpad.prepare();
        _isReady = true;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Lỗi khởi tạo PianoDetectionService: $e');
      return false;
    }
  }

  /// Bắt đầu nhận diện âm thanh với callback
  void startDetection(Function(List<String>) onNotesDetected) {
    if (!_isReady) {
      print('Engine chưa sẵn sàng!');
      return;
    }

    _fpad.start();
    _isRecording = true;

    _resultStream = _fpad.startAudioRecognition();
    _resultStream!.listen((event) {
      // Lọc các nốt theo ngưỡng âm lượng
      List<dynamic> filteredEvent = event
          .where((e) => (e["velocity"] as double) > _volumeThreshold)
          .toList();

      // Lấy danh sách tên nốt nhạc
      List<String> detectedNotes = _fpad.getNotes(filteredEvent);

      if (detectedNotes.isNotEmpty) {
        onNotesDetected(detectedNotes);
      }
    });
  }

  /// Dừng nhận diện âm thanh
  void stopDetection() {
    if (_isRecording) {
      _fpad.stop();
      _isRecording = false;
    }
  }

  /// Đặt ngưỡng âm lượng (0.0 - 1.0)
  void setVolumeThreshold(double threshold) {
    _volumeThreshold = threshold.clamp(0.0, 1.0);
  }

  /// Kiểm tra xem nốt được phát hiện có khớp với nốt mục tiêu không
  /// Chỉ so sánh tên nốt (C, D, E...) không quan tâm octave
  bool checkNoteMatch(List<String> detectedNotes, String targetNoteName) {
    for (String note in detectedNotes) {
      // Lấy tên nốt cơ bản (bỏ số octave)
      String baseName = note.replaceAll(RegExp(r'[0-9]'), '');
      String targetBase = targetNoteName.replaceAll(RegExp(r'[0-9]'), '');

      if (baseName == targetBase) {
        return true;
      }
    }
    return false;
  }

  /// Giải phóng tài nguyên
  void dispose() {
    stopDetection();
  }
}
