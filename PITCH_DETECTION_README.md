# Pitch Detection Feature - Hướng dẫn sử dụng

## Tổng quan
Tính năng này sử dụng thư viện `pitch_detector_dart` để phát hiện nốt nhạc từ giọng hát hoặc nhạc cụ thông qua microphone.

## Files đã tạo

### 1. Service: `lib/services/pitch_detection_service.dart`
Service này chịu trách nhiệm:
- Ghi âm từ microphone
- Phát hiện tần số (frequency) từ audio stream
- Chuyển đổi tần số sang tên nốt nhạc (ví dụ: 440Hz → A4)

**Các phương thức chính:**
- `initialize()`: Khởi tạo pitch detector
- `startRecording()`: Bắt đầu ghi âm và phát hiện nốt
- `stopRecording()`: Dừng ghi âm
- `dispose()`: Giải phóng tài nguyên

**Callbacks:**
- `onPitchDetected(String note, double frequency, double probability)`: Được gọi khi phát hiện nốt nhạc
- `onRecordingStateChanged(bool isRecording)`: Được gọi khi trạng thái ghi âm thay đổi

### 2. UI Screen: `lib/screen/main_note_screen/learning_screen.dart`
Màn hình hiển thị:
- Nút bắt đầu/dừng ghi âm
- Nốt nhạc hiện tại (ví dụ: A4, C#5)
- Tần số (Hz)
- Độ chính xác (%)

### 3. Test App: `lib/main_pitch_test.dart`
File để test tính năng pitch detection độc lập.

## Cách chạy test

```bash
# Chạy với file test
flutter run -t lib/main_pitch_test.dart

# Hoặc chạy app chính và navigate đến LearningScreen
flutter run
```

## Permissions đã cấu hình

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to the microphone to detect pitch and musical notes.</string>
```

## Công thức chuyển đổi tần số

### Từ Frequency → Note Name
```
n = 12 × log₂(f/440) + 69
```
Trong đó:
- f: tần số (Hz)
- n: MIDI note number
- 440Hz = A4 (MIDI note 69)

### Từ Note Name → Frequency
```
f = 440 × 2^((n-69)/12)
```

### Ví dụ các nốt phổ biến:
- C4 (Middle C): 261.63 Hz
- D4: 293.66 Hz
- E4: 329.63 Hz
- F4: 349.23 Hz
- G4: 392.00 Hz
- A4: 440.00 Hz (chuẩn)
- B4: 493.88 Hz
- C5: 523.25 Hz

## Dependencies đã thêm

```yaml
dependencies:
  pitch_detector_dart: ^0.0.7  # Phát hiện pitch
  record: ^5.0.0               # Ghi âm
  permission_handler: ^11.0.0  # Xử lý permissions
```

## Cách tích hợp vào app chính

Thêm navigation đến LearningScreen từ HomeScreen hoặc bất kỳ màn hình nào:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const LearningScreen(),
  ),
);
```

## Lưu ý
- Cần chạy trên thiết bị thật hoặc emulator có microphone
- Lần đầu sử dụng cần cấp quyền microphone
- Hoạt động tốt nhất trong môi trường yên tĩnh
- Độ chính xác phụ thuộc vào chất lượng microphone và âm thanh đầu vào
