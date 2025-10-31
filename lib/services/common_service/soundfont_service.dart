import 'package:flutter_midi_pro/flutter_midi_pro.dart';

class SoundfontService {
  static final MidiPro _midiPro = MidiPro();
  static int? _sfId;
  static bool _isLoaded = false;

  static Future<void> loadSoundfont() async {
    if (_isLoaded) return;
    _sfId = await _midiPro.loadSoundfontAsset(
      assetPath: 'assets/Grand_Piano.sf2',
      bank: 0,
      program: 0,
    );
    await _midiPro.selectInstrument(
        sfId: _sfId!, channel: 0, bank: 0, program: 0);
    _isLoaded = true;
  }

  static Future<void> playNote(int midiNote, {int velocity = 120}) async {
    if (!_isLoaded || _sfId == null) return;
    await _midiPro.playNote(
        channel: 0, key: midiNote, velocity: velocity, sfId: _sfId!);
  }

  static Future<void> stopNote(int midiNote) async {
    if (!_isLoaded || _sfId == null) return;
    await _midiPro.stopNote(channel: 0, key: midiNote, sfId: _sfId!);
  }

  static void dispose() {
    if (_sfId != null) {
      _midiPro.unloadSoundfont(_sfId!);

      _sfId = null;
      _isLoaded = false;
    }
  }

  static int? getSfId() => _sfId;
}
