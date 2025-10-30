import 'package:flutter/material.dart';
import 'package:flutter_piano_audio_detection/flutter_piano_audio_detection.dart';
import 'package:permission_handler/permission_handler.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({Key? key}) : super(key: key);

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final FlutterPianoAudioDetection fpad = FlutterPianoAudioDetection();
  Stream<List<dynamic>>? result;
  List<String> detectedNotes = [];
  bool isRecording = false;
  bool isReady = false;
  double volumeThreshold = 0.7;

  @override
  void initState() {
    super.initState();
    _initializePianoDetection();
  }

  Future<void> _initializePianoDetection() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        await fpad.prepare();
        setState(() => isReady = true);
        _showSnackBar('Sẵn sàng nhận diện nốt nhạc!');
      } else {
        _showSnackBar('Cần quyền microphone để nhận diện âm thanh!');
      }
    } catch (e) {
      _showSnackBar('Lỗi khởi tạo: $e');
    }
  }

  void _startDetection() {
    if (!isReady) {
      _showSnackBar('Engine chưa sẵn sàng!');
      return;
    }
    fpad.start();
    _getResult();
    setState(() => isRecording = true);
    _showSnackBar('Đang nhận diện...');
  }

  void _stopDetection() {
    fpad.stop();
    setState(() {
      isRecording = false;
      detectedNotes.clear();
    });
    _showSnackBar('Đã dừng nhận diện.');
  }

  void _getResult() {
    result = fpad.startAudioRecognition();
    result!.listen((event) {
      List<dynamic> filteredEvent = event
          .where((e) => (e["velocity"] as double) > volumeThreshold)
          .toList();
      setState(() {
        detectedNotes = fpad.getNotes(filteredEvent);
      });
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    if (isRecording) fpad.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng Theme để lấy màu sắc nhất quán
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // Nền tối
      appBar: AppBar(
        title: const Text('Piano Note Detector'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Phần hiển thị trạng thái (đã tối giản)
              _buildStatusIndicator(),

              const SizedBox(height: 16),

              // Slider điều chỉnh ngưỡng âm lượng
              _buildVolumeThresholdSlider(),

              const SizedBox(height: 24),

              // Phần hiển thị nốt nhạc
              Expanded(
                child: _buildNotesDisplayArea(theme),
              ),

              const SizedBox(height: 24),

              // Nút điều khiển
              _buildControlButtons(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Widget con cho khu vực trạng thái
  Widget _buildStatusIndicator() {
    return Column(
      children: [
        Icon(
          isRecording ? Icons.mic : Icons.mic_none,
          size: 48,
          color: isRecording ? Colors.redAccent : Colors.white54,
        ),
        const SizedBox(height: 8),
        Text(
          isRecording ? 'ĐANG GHI ÂM' : 'NHẤN ĐỂ BẮT ĐẦU',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isRecording ? Colors.redAccent : Colors.white54,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  // Widget con cho khu vực hiển thị nốt nhạc
  Widget _buildNotesDisplayArea(ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: detectedNotes.isEmpty
          ? Center(
              child: Text(
                isRecording ? 'Đang lắng nghe...' : 'Chưa có dữ liệu',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: detectedNotes.map((note) {
                  return Chip(
                    label: Text(note),
                    labelStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.amberAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }

  // Widget con cho slider ngưỡng âm lượng
  Widget _buildVolumeThresholdSlider() {
    return Column(
      children: [
        Text(
          'Ngưỡng âm lượng: ${(volumeThreshold * 100).round()}%',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        Slider(
          value: volumeThreshold,
          min: 0.0,
          max: 1.0,
          divisions: 100,
          activeColor: Colors.blueAccent,
          inactiveColor: Colors.grey.shade600,
          onChanged: (value) {
            setState(() {
              volumeThreshold = value;
            });
          },
        ),
      ],
    );
  }

  // Widget con cho các nút điều khiển
  Widget _buildControlButtons() {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: isReady && !isRecording ? _startDetection : null,
            icon: const Icon(Icons.play_arrow),
            label: const Text('BẮT ĐẦU'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              backgroundColor: Colors.blueAccent,
              disabledBackgroundColor: Colors.grey.shade800,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton.icon(
            onPressed: isRecording ? _stopDetection : null,
            icon: const Icon(Icons.stop),
            label: const Text('DỪNG'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              backgroundColor: Colors.redAccent.withOpacity(0.8),
              disabledBackgroundColor: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
