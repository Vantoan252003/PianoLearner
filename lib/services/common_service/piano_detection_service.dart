import 'package:flutter_piano_audio_detection/flutter_piano_audio_detection.dart';
import 'package:permission_handler/permission_handler.dart';

class PianoDetectionService {
  final FlutterPianoAudioDetection _fpad = FlutterPianoAudioDetection();
  Stream<List<dynamic>>? _resultStream;
  bool _isReady = false;
  bool _isRecording = false;
  double _volumeThreshold = 0.5;

  bool get isReady => _isReady;
  bool get isRecording => _isRecording;
  double get volumeThreshold => _volumeThreshold;

  Future<bool> initialize() async {
    if (await Permission.microphone.request().isGranted) {
      await _fpad.prepare();
      _isReady = true;
      return true;
    } else {
      return false;
    }
  }

  void startDetection(Function(List<String>) onNotesDetected) {
    if (!_isReady) {
      return;
    }
    _fpad.start();
    _isRecording = true;
    _resultStream = _fpad.startAudioRecognition();
    _resultStream!.listen((event) {
      List<dynamic> filteredEvent = event
          .where((e) => (e["velocity"] as double) > _volumeThreshold)
          .toList();
      List<String> detectedNotes = _fpad.getNotes(filteredEvent);

      if (detectedNotes.isNotEmpty) {
        onNotesDetected(detectedNotes);
      }
    });
  }

  void stopDetection() {
    if (_isRecording) {
      _fpad.stop();
      _isRecording = false;
    }
  }

  void setVolumeThreshold(double threshold) {
    _volumeThreshold = threshold.clamp(0.0, 1.0);
  }

  /// Kiểm tra xem nốt được phát hiện có khớp với nốt mục tiêu không
  /// Chỉ so sánh tên nốt (C, D, E...) không quan tâm octave
  bool checkNoteMatch(List<String> detectedNotes, String targetNoteName) {
    for (String note in detectedNotes) {
      String baseName = note.replaceAll(RegExp(r'[0-9]'), '');
      String targetBase = targetNoteName.replaceAll(RegExp(r'[0-9]'), '');

      if (baseName == targetBase) {
        return true;
      }
    }
    return false;
  }

  void dispose() {
    stopDetection();
  }
}
