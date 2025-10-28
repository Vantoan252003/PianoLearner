import 'package:flutter/material.dart';
import '../../services/pitch_detection_service.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final PitchDetectionService _pitchService = PitchDetectionService();

  String _currentNote = '--';
  double _currentFrequency = 0.0;
  double _currentProbability = 0.0;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializePitchDetection();
  }

  void _initializePitchDetection() {
    _pitchService.initialize();

    // Callback khi phát hiện pitch
    _pitchService.onPitchDetected = (note, frequency, probability) {
      if (mounted) {
        setState(() {
          _currentNote = note;
          _currentFrequency = frequency;
          _currentProbability = probability;
        });
      }
    };

    // Callback khi trạng thái recording thay đổi
    _pitchService.onRecordingStateChanged = (isRecording) {
      if (mounted) {
        setState(() {
          _isRecording = isRecording;
        });
      }
    };
  }

  void _toggleRecording() async {
    if (_isRecording) {
      await _pitchService.stopRecording();
      setState(() {
        _currentNote = '--';
        _currentFrequency = 0.0;
        _currentProbability = 0.0;
      });
    } else {
      await _pitchService.startRecording();
    }
  }

  @override
  void dispose() {
    _pitchService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pitch Detection - Learning'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon microphone với animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _isRecording ? Colors.red.shade100 : Colors.grey.shade200,
                  boxShadow: _isRecording
                      ? [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ]
                      : [],
                ),
                child: Icon(
                  _isRecording ? Icons.mic : Icons.mic_none,
                  size: 80,
                  color: _isRecording ? Colors.red : Colors.grey,
                ),
              ),

              const SizedBox(height: 60),

              // Hiển thị nốt nhạc hiện tại
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Nốt nhạc',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _currentNote,
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: _isRecording ? Colors.deepPurple : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Thông tin chi tiết
              if (_isRecording && _currentFrequency > 0)
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'Tần số',
                        '${_currentFrequency.toStringAsFixed(2)} Hz',
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        'Độ chính xác',
                        '${(_currentProbability * 100).toStringAsFixed(1)}%',
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 60),

              // Nút bắt đầu/dừng
              ElevatedButton(
                onPressed: _toggleRecording,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isRecording ? Colors.red : Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  _isRecording ? 'Dừng ghi âm' : 'Bắt đầu ghi âm',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Hướng dẫn
              if (!_isRecording)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Nhấn nút để bắt đầu ghi âm và phát hiện nốt nhạc',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}
