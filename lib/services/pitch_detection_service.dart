import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:record/record.dart';

class PitchDetectionService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  late PitchDetector _pitchDetector;
  StreamSubscription<Uint8List>? _recordingSubscription;

  // Callbacks
  Function(String note, double frequency, double probability)? onPitchDetected;
  Function(bool isRecording)? onRecordingStateChanged;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  // Buffer để tích lũy audio data
  final List<int> _audioBuffer = [];
  static const int _requiredBufferSize =
      2048; // Giảm xuống 1024 samples (2048 bytes) để xử lý nhanh hơn

  // Khởi tạo pitch detector
  void initialize() {
    // Khởi tạo PitchDetector với sample rate và buffer size
    // audioSampleRate: 44100 Hz (chuẩn CD quality)
    // bufferSize: 1024 samples (giảm tối thiểu để nhạy tối đa)
    _pitchDetector = PitchDetector(
      audioSampleRate: 44100.0,
      bufferSize: 1024,
    );
  }

  // Bắt đầu ghi âm
  Future<void> startRecording() async {
    try {
      debugPrint('Checking microphone permission...');

      // Kiểm tra permission
      if (await _audioRecorder.hasPermission()) {
        debugPrint('Permission granted, starting recording...');

        // Cấu hình ghi âm với bit depth cao hơn và autoGain
        const config = RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 44100,
          numChannels: 1,
          autoGain: true, // Tự động điều chỉnh gain
          echoCancel: false, // Tắt echo cancellation để giữ nguyên tín hiệu
          noiseSuppress: false, // Tắt noise suppression để giữ tín hiệu yếu
        );

        // Bắt đầu stream recording
        final stream = await _audioRecorder.startStream(config);

        debugPrint('Recording stream started successfully');

        _isRecording = true;
        onRecordingStateChanged?.call(true);

        // Lắng nghe stream và xử lý audio data
        _recordingSubscription = stream.listen(
          (audioData) {
            _processAudioData(audioData);
          },
          onError: (error) {
            debugPrint('Stream error: $error');
          },
          onDone: () {
            debugPrint('Stream done');
          },
        );
      } else {
        debugPrint('Microphone permission denied');
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
      _isRecording = false;
      onRecordingStateChanged?.call(false);
    }
  }

  // Dừng ghi âm
  Future<void> stopRecording() async {
    try {
      await _recordingSubscription?.cancel();
      await _audioRecorder.stop();
      _isRecording = false;
      _audioBuffer.clear(); // Clear buffer
      onRecordingStateChanged?.call(false);
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  // Xử lý audio data và phát hiện pitch
  void _processAudioData(Uint8List audioData) async {
    if (audioData.isEmpty) return;

    try {
      // Thêm data vào buffer
      _audioBuffer.addAll(audioData);

      // Chỉ log khi buffer đạt ngưỡng
      // debugPrint('Buffer size: ${_audioBuffer.length} / $_requiredBufferSize bytes');

      // Kiểm tra nếu buffer đủ lớn để xử lý
      if (_audioBuffer.length >= _requiredBufferSize) {
        // Lấy một phần buffer để xử lý
        final bufferToProcess =
            Uint8List.fromList(_audioBuffer.take(_requiredBufferSize).toList());

        // Xóa toàn bộ phần đã xử lý (không overlap nữa)
        _audioBuffer.removeRange(0, _requiredBufferSize);

        // Phát hiện pitch từ buffer
        final result =
            await _pitchDetector.getPitchFromIntBuffer(bufferToProcess);

        // Chỉ log khi có kết quả quan trọng
        debugPrint(
            'Pitch: ${result.pitch.toStringAsFixed(2)} Hz, Prob: ${(result.probability * 100).toStringAsFixed(1)}%, Pitched: ${result.pitched}');

        // BỎ HẾT THRESHOLD - chấp nhận mọi kết quả để test
        if (result.pitch > 0) {
          final frequency = result.pitch;
          final probability = result.probability;

          // Chuyển đổi frequency sang note
          final note = _frequencyToNote(frequency);

          // GỬI NGAY KẾT QUẢ - KHÔNG LÀM MƯỢT
          debugPrint(
              '🎵 Note: $note, Freq: ${frequency.toStringAsFixed(2)} Hz, Prob: ${(probability * 100).toStringAsFixed(1)}%');
          onPitchDetected?.call(note, frequency, probability);
        }
      }
    } catch (e) {
      debugPrint('Error processing audio data: $e');
    }
  }

  // Chuyển đổi frequency (Hz) sang tên nốt nhạc
  String _frequencyToNote(double frequency) {
    // A4 = 440 Hz là điểm chuẩn
    const double a4 = 440.0;
    const int a4MidiNumber = 69;

    // Tính MIDI note number: n = 12 * log2(f/440) + 69
    final double halfSteps = 12 * (log(frequency / a4) / log(2));
    final int midiNumber = (a4MidiNumber + halfSteps.round());

    // Map MIDI number sang tên nốt (chú ý: MIDI note 0 = C-1)
    final noteNames = [
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B'
    ];

    final int noteIndex = midiNumber % 12;
    final int octave = (midiNumber ~/ 12) - 1;

    final noteName = '${noteNames[noteIndex]}$octave';

    // Debug: Log chi tiết với tần số chuẩn để so sánh
    // C4=261.63, D4=293.66, E4=329.63, F4=349.23, G4=392.00, A4=440, B4=493.88, C5=523.25
    debugPrint(
        'Frequency: ${frequency.toStringAsFixed(2)} Hz -> MIDI: $midiNumber -> Note: $noteName');

    // Tính frequency chuẩn của nốt được phát hiện
    final standardFreq = a4 * pow(2, (midiNumber - a4MidiNumber) / 12);
    final cents = 1200 * log(frequency / standardFreq) / log(2);
    debugPrint(
        'Standard frequency for $noteName: ${standardFreq.toStringAsFixed(2)} Hz, deviation: ${cents.toStringAsFixed(1)} cents');

    return noteName;
  }

  // Chuyển đổi tên nốt sang frequency (Hz)
  double noteToFrequency(String note) {
    final noteNames = {
      'C': 0,
      'C#': 1,
      'D': 2,
      'D#': 3,
      'E': 4,
      'F': 5,
      'F#': 6,
      'G': 7,
      'G#': 8,
      'A': 9,
      'A#': 10,
      'B': 11
    };

    // Parse note name và octave
    final regex = RegExp(r'([A-G]#?)(\d+)');
    final match = regex.firstMatch(note);

    if (match == null) return 0.0;

    final noteName = match.group(1)!;
    final octave = int.parse(match.group(2)!);

    final noteIndex = noteNames[noteName] ?? 0;
    final midiNumber = (octave + 1) * 12 + noteIndex;

    // f = 440 * 2^((n-69)/12)
    const double a4 = 440.0;
    const int a4MidiNumber = 69;

    return a4 * pow(2, (midiNumber - a4MidiNumber) / 12);
  }

  // Cleanup
  void dispose() {
    _recordingSubscription?.cancel();
    _audioRecorder.dispose();
  }
}
