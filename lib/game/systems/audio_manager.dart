import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  bool _initialized = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      await FlameAudio.audioCache.loadAll([
        'shoot.wav',
        'explosion.wav',
        'hit.wav',
        'powerup.wav',
        'game_over.wav',
        'victory.wav',
      ]);
      _initialized = true;
    } catch (e) {
      print('Audio initialization failed: $e');
      _initialized = false;
    }
  }
  
  void playShoot() {
    if (!_soundEnabled || !_initialized) return;
    FlameAudio.play('shoot.wav', volume: 0.5);
  }
  
  void playExplosion() {
    if (!_soundEnabled || !_initialized) return;
    FlameAudio.play('explosion.wav', volume: 0.7);
  }
  
  void playHit() {
    if (!_soundEnabled || !_initialized) return;
    FlameAudio.play('hit.wav', volume: 0.4);
  }
  
  void playPowerUp() {
    if (!_soundEnabled || !_initialized) return;
    FlameAudio.play('powerup.wav', volume: 0.6);
  }
  
  void playGameOver() {
    if (!_soundEnabled || !_initialized) return;
    FlameAudio.play('game_over.wav', volume: 0.8);
  }
  
  void playVictory() {
    if (!_soundEnabled || !_initialized) return;
    FlameAudio.play('victory.wav', volume: 0.8);
  }
  
  void startBackgroundMusic() {
    if (!_musicEnabled || !_initialized) return;
    try {
      FlameAudio.bgm.play('background.mp3', volume: 0.3);
    } catch (e) {
      print('Background music failed: $e');
    }
  }
  
  void stopBackgroundMusic() {
    FlameAudio.bgm.stop();
  }
  
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }
  
  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    if (!_musicEnabled) {
      stopBackgroundMusic();
    }
  }
  
  bool get isSoundEnabled => _soundEnabled;
  bool get isMusicEnabled => _musicEnabled;
}