import 'package:audioplayers/audioplayers.dart';

class Level1Bgm {
  static final AudioPlayer _player = AudioPlayer();
  static bool _started = false;

  static Future<void> play() async {
    if (_started) return;

    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(
      AssetSource('Audios/bgsound.mp3'),
      volume: 0.5,
    );

    _started = true;
  }

  static Future<void> stop() async {
    await _player.stop();
    _started = false;
  }
}
